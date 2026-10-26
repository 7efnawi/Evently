import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evently/utils/app_style.dart';
import 'package:evently/utils/app_color.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AppStyle Typography Verification', () {
    test('Font family and weights must comply with Figma specifications', () {
      expect(AppStyle.bold24.fontSize, 24);
      expect(AppStyle.bold24.fontWeight, FontWeight.w700);

      expect(AppStyle.bold20.fontSize, 20);
      expect(AppStyle.bold20.fontWeight, FontWeight.w700);

      expect(AppStyle.medium16.fontSize, 16);
      expect(AppStyle.medium16.fontWeight, FontWeight.w500);

      expect(AppStyle.regular14.fontSize, 14);
      expect(AppStyle.regular14.fontWeight, FontWeight.w400);

      expect(AppStyle.bold14.fontSize, 14);
      expect(AppStyle.bold14.fontWeight, FontWeight.w700);

      expect(AppStyle.logo36.fontSize, 36);
      expect(AppStyle.logo36.color, AppColor.primary);
    });
  });
}
