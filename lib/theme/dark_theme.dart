import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  cardColor: AppColors.card,
  colorScheme: ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.buttonPrimary,
    surface: AppColors.card,
    background: AppColors.background,
    onPrimary: AppColors.textPrimary,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
    onBackground: AppColors.textPrimary,
    error: AppColors.warning,
    onError: AppColors.textPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: AppColors.textPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'PlayfairDisplay',
      color: AppColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'PlayfairDisplay',
      color: AppColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'PlayfairDisplay',
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
  ),
  fontFamily: 'Poppins',
);
