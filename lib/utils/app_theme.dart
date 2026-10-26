import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_style.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          surface: AppColor.backgroundLight,
          onPrimary: AppColor.white,
          onSurface: AppColor.textBaseDark,
          error: AppColor.dangerRed,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.backgroundLight,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppStyle.bold20,
          iconTheme: const IconThemeData(color: AppColor.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppStyle.medium16.copyWith(color: AppColor.white),
            minimumSize: const Size.fromHeight(56),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColor.white,
          hintStyle: AppStyle.regular14,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.textSecondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.textSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColor.primary,
        scaffoldBackgroundColor: AppColor.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColor.primary,
          surface: AppColor.backgroundDark,
          onPrimary: AppColor.white,
          onSurface: AppColor.white,
          error: AppColor.dangerRed,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.backgroundDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppStyle.bold20.copyWith(color: AppColor.white),
          iconTheme: const IconThemeData(color: AppColor.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: AppStyle.medium16.copyWith(color: AppColor.white),
            minimumSize: const Size.fromHeight(56),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColor.backgroundDark,
          hintStyle: AppStyle.regular14.copyWith(color: AppColor.textSecondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
          ),
        ),
      );
}
