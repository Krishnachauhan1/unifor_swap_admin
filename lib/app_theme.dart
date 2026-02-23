import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          error: AppColors.error,
          onError: AppColors.onError,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: AppColors.surface,
          hintStyle: const TextStyle(color: AppColors.textHint),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        scaffoldBackgroundColor: AppColors.background,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          error: AppColors.error,
          onError: AppColors.onError,
          surface: AppColors.surfaceDark,
          onSurface: AppColors.textPrimaryDark,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.backgroundDark,
            foregroundColor: AppColors.textPrimaryDark,
            elevation: 0),
        cardTheme: CardThemeData(
            color: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        scaffoldBackgroundColor: AppColors.backgroundDark,
      );
}
