import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import '../core/app_user.dart';
import 'dart:convert';
import 'sms_verify_dialog.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = AppUser.fromJson(jsonDecode(userJson));
      setState(() {
        _name = user.fullName;
      });
      AppUserManager.currentUser = user;
      setState(() {}); // Kullanıcı güncellendiğinde widget'ı yenile
    } else {
      setState(() {
        _name = '';
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  bool get _isVerified {
    final user = AppUserManager.currentUser;
    return user?.isVerified ?? true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dialogdan döndükten sonra tekrar kontrol et
    Future.delayed(Duration.zero, _loadName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        title: Text(
          _name ?? '',
          style: const TextStyle(fontFamily: "PlayfairDisplay", fontWeight: FontWeight.normal, color: AppColors.accent),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () => _logout(context),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          if (!_isVerified)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) => SmsVerifyDialog(
                      name: AppUserManager.currentUser?.fullName ?? '',
                      phone: AppUserManager.currentUser?.phoneNumber ?? '',
                      salonNumber: '',
                    ),
                  );
                  if (result == true) {
                    await _loadName();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Hesabınız doğrulanmadı, randevu oluşturabilmek için lütfen doğrulayınız',
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const Expanded(
            child: Center(
              child: Text(
                'Hoş geldiniz! Giriş başarılı.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
