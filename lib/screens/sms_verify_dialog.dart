import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer_home_screen.dart';

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
  String? _errorText;
  int _secondsLeft = 300;
  Timer? _timer;
  final String _correctCode = '123456'; // Demo amaçlı

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode() async {
    if (_codeController.text == _correctCode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', widget.phone);
      await prefs.setString('name', widget.name);
      await prefs.setString('salonNumber', widget.salonNumber);
      await prefs.setString('jwtToken', 'demo_jwt_token');
      await prefs.setString('userType', 'musteri');
      Navigator.of(context).pop(); // Dialogu kapat
      Future.microtask(() {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
          (route) => false,
        );
      });
    } else {
      setState(() {
        _errorText = 'Yanlış kod girdiniz';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTimeUp = _secondsLeft == 0;
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text('SMS Onay Kodu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    'Süreniz doldu. Lütfen tekrar kod isteyin.',
                    style: TextStyle(color: Colors.redAccent),
                  )
                : Text(
                    'Kalan süre: ${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: isTimeUp ? null : _verifyCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.background,
          ),
          child: const Text('Onayla'),
        ),
      ],
    );
  }
}
