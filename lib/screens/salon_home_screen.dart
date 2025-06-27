import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SalonHomeScreen extends StatelessWidget {
  const SalonHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Salon Ana Sayfası'),
      ),
      body: const Center(
        child: Text(
          'Hoş geldiniz! (Salon Sahibi)',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
