import 'package:flutter/material.dart';
import 'theme/dark_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/customer_home_screen.dart';
import 'screens/salon_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KuafiApp());
}

class KuafiApp extends StatelessWidget {
  const KuafiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuafi',
      theme: darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/customerHome': (context) => const CustomerHomeScreen(),
        '/salonHome': (context) => const SalonHomeScreen(),
      },
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/logo/kuafi-logo.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            child!,
          ],
        );
      },
    );
  }
}
