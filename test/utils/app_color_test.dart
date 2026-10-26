import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evently/utils/app_color.dart';

void main() {
  group('AppColor Figma Token Verification', () {
    test('AppColor must match exact hex values from Figma design file', () {
      expect(AppColor.primary, const Color(0xFF5669FF));
      expect(AppColor.backgroundLight, const Color(0xFFF2FEFF));
      expect(AppColor.backgroundDark, const Color(0xFF101127));
      expect(AppColor.cardDark, const Color(0xFF1C1C1C));
      expect(AppColor.textBaseDark, const Color(0xFF0F0F0F));
      expect(AppColor.textSecondary, const Color(0xFF7B7B7B));
      expect(AppColor.accentCream, const Color(0xFFF4EBDC));
      expect(AppColor.dangerRed, const Color(0xFFFF5659));
      expect(AppColor.white, const Color(0xFFFFFFFF));
    });
  });
}
