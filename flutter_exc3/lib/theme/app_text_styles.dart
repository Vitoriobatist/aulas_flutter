import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle _pjs(double size, FontWeight weight, Color color,
      {double? letterSpacing}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Títulos
  static TextStyle get headlineLarge =>
      _pjs(22, FontWeight.w800, AppColors.textPrimary);

  static TextStyle get headlineMedium =>
      _pjs(17, FontWeight.w800, AppColors.textPrimary);

  static TextStyle get headlineSmall =>
      _pjs(14, FontWeight.w700, AppColors.primary);

  // Corpo
  static TextStyle get bodyLarge =>
      _pjs(15, FontWeight.w500, AppColors.textSecondary);

  static TextStyle get bodyMedium =>
      _pjs(13, FontWeight.w500, AppColors.textSecondary);

  static TextStyle get bodySmall =>
      _pjs(12, FontWeight.w500, AppColors.textMuted);

  // Labels
  static TextStyle get labelLarge =>
      _pjs(15, FontWeight.w700, Colors.white);

  static TextStyle get labelMedium =>
      _pjs(13, FontWeight.w600, AppColors.primary);

  static TextStyle get labelSmall =>
      _pjs(10, FontWeight.w700, AppColors.textDisabled,
          letterSpacing: 0.3);

  // Seção
  static TextStyle get sectionTitle =>
      _pjs(13, FontWeight.w700, AppColors.primary);

  // Caption (coordenadas GPS)
  static TextStyle get caption =>
      _pjs(10, FontWeight.w600, AppColors.textDisabled,
          letterSpacing: 0.5);

  // Estatísticas (SummaryBar)
  static TextStyle get statValue =>
      _pjs(18, FontWeight.w800, AppColors.textPrimary);

  static TextStyle get statLabel =>
      _pjs(9, FontWeight.w600, AppColors.textDisabled, letterSpacing: 0.3);

  // AppBar / Header
  static TextStyle get appBarTitle =>
      _pjs(16, FontWeight.w700, Colors.white);

  static TextStyle get appBarSubtitle =>
      _pjs(10, FontWeight.w500, AppColors.textDisabled);

  static TextStyle get appBarBrand =>
      _pjs(17, FontWeight.w800, AppColors.textPrimary);
}
