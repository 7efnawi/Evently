import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/utils/app_theme.dart';
import 'package:evently/utils/app_color.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AppTheme Configuration Verification', () {
    test('Light theme properties should match Figma specs', () {
      final theme = AppTheme.lightTheme;
      expect(theme.scaffoldBackgroundColor, AppColor.backgroundLight);
      expect(theme.primaryColor, AppColor.primary);
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('Dark theme properties should match Figma specs', () {
      final theme = AppTheme.darkTheme;
      expect(theme.scaffoldBackgroundColor, AppColor.backgroundDark);
      expect(theme.primaryColor, AppColor.primary);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });
  });
}
