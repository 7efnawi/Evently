import 'package:flutter/material.dart';

abstract final class AppColor {
  /// Figma Brand Primary: #5669FF
  static const Color primary = Color(0xFF5669FF);

  /// Figma Light Theme Background: #F2FEFF
  static const Color backgroundLight = Color(0xFFF2FEFF);

  /// Figma Dark Theme Background: #101127
  static const Color backgroundDark = Color(0xFF101127);

  /// Figma Dark Card / Surface: #1C1C1C
  static const Color cardDark = Color(0xFF1C1C1C);

  /// Figma High-contrast dark text: #0F0F0F
  static const Color textBaseDark = Color(0xFF0F0F0F);

  /// Figma Muted text / grey borders: #7B7B7B
  static const Color textSecondary = Color(0xFF7B7B7B);

  /// Figma Accent Cream / Tags: #F4EBDC
  static const Color accentCream = Color(0xFFF4EBDC);

  /// Figma Danger / Delete / Active Heart: #FF5659
  static const Color dangerRed = Color(0xFFFF5659);

  /// Pure White: #FFFFFF
  static const Color white = Color(0xFFFFFFFF);

  /// Transparent
  static const Color transparent = Colors.transparent;
}
