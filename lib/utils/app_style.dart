import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

abstract final class AppStyle {
  /// Logo 36px font: Jockey One
  static TextStyle get logo36 => GoogleFonts.jockeyOne(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColor.primary,
        letterSpacing: -0.0083,
      );

  /// Inter Bold 24px
  static TextStyle get bold24 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColor.textBaseDark,
      );

  /// Inter Bold 20px
  static TextStyle get bold20 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColor.textBaseDark,
      );

  /// Inter Medium 20px
  static TextStyle get medium20 => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColor.textBaseDark,
      );

  /// Inter Bold 16px
  static TextStyle get bold16 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColor.textBaseDark,
      );

  /// Inter Medium 16px
  static TextStyle get medium16 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColor.textBaseDark,
      );

  /// Inter Regular 14px
  static TextStyle get regular14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColor.textSecondary,
      );

  /// Inter Medium 14px
  static TextStyle get medium14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColor.textBaseDark,
      );

  /// Inter Bold 14px
  static TextStyle get bold14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColor.textBaseDark,
      );

  /// Inter Bold 12px
  static TextStyle get bold12 => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColor.primary,
      );
}
