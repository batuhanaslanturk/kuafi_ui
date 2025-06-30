import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/customer_service.dart';
import '../core/app_user.dart';
import 'dart:convert';

class SmsVerifyDialog extends StatefulWidget {
  final String name;
  final String phone;
  final String salonNumber;
  const SmsVerifyDialog({super.key, required this.name, required this.phone, required this.salonNumber});

  @override
  State<SmsVerifyDialog> createState() => _SmsVerifyDialogState();
}

class _SmsVerifyDialogState extends State<SmsVerifyDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;
  int _secondsLeft = 0;
  Timer? _timer;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _secondsLeft = 0;
    _codeSent = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    setState(() {
      _errorText = null;
    });
    final response = await CustomerService.sendCode();
    if (response.statusCode == 200) {
      setState(() {
        _codeSent = true;
        _secondsLeft = 300;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() {
            _secondsLeft--;
          });
        } else {
          timer.cancel();
        }
      });
    } else {
      try {
        final data = jsonDecode(response.body);
        setState(() {
          _errorText = data['message'] ?? 'Kod gönderilemedi. Lütfen tekrar deneyin.';
        });
      } catch (_) {
        setState(() {
          _errorText = 'Kod gönderilemedi. Lütfen tekrar deneyin.';
        });
      }
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorText = 'Kod giriniz';
      });
      return;
    }
    final response = await CustomerService.verifyCode(code);
    if (response.statusCode == 200) {
      // Kullanıcıyı verified yap
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = AppUser.fromJson(jsonDecode(userJson));
        final updatedUser = AppUser(
          id: user.id,
          fullName: user.fullName,
          profilePhoto: user.profilePhoto,
          isVerified: true,
          phoneNumber: user.phoneNumber,
          userType: user.userType,
        );
        await prefs.setString('user', jsonEncode(updatedUser.toJson()));
        AppUserManager.currentUser = updatedUser;
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        setState(() {
          _errorText = data['message'] ?? 'Doğrulama başarısız.';
        });
      } catch (_) {
        setState(() {
          _errorText = 'Doğrulama başarısız.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTimeUp = _secondsLeft == 0 && _codeSent;
    final phone = widget.phone;
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('Telefon Doğrulama'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Telefon numaranız: $phone',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (!_codeSent) ...[
            ElevatedButton.icon(
              onPressed: _sendCode,
              icon: const Icon(Icons.send),
              label: const Text('Kodu Gönder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
              ),
            ),
          ] else ...[
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              enabled: !isTimeUp,
              decoration: InputDecoration(
                labelText: 'Onay Kodu',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: isTimeUp
                  ? const Text(
                      'Kodu tekrar göndermek için 5 dakika bekleyin.',
                      style: TextStyle(color: Colors.redAccent),
                    )
                  : Text(
                      'Kalan süre: \n${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: isTimeUp ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
              ),
              child: const Text('Onayla'),
            ),
          ],
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(_errorText!, style: const TextStyle(color: Colors.redAccent)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
      ],
    );
  }
}
