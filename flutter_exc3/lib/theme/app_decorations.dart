import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppDecorations {
  // Raios
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusPill = 100;
  static const double radiusXL = 20;

  // Sombras
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0x0A000000),
          blurRadius: 0,
          offset: Offset.zero,
        ),
      ];

  static List<BoxShadow> get fabShadow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.20),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get menuShadow => [
        BoxShadow(
          color: const Color(0x1F000000),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // Decorações de card
  static BoxDecoration get deliveryCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radiusLarge),
        border: Border.all(color: AppColors.dividerLight),
      );

  static BoxDecoration get summaryItemCard => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: AppColors.dividerLight),
      );

  // InputDecoration padronizada
  static InputDecoration inputDecoration({
    required String hint,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textDisabled,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // Badge de status
  static BoxDecoration statusBadge(Color color) => BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radiusPill),
      );

  // Container do ícone de status no card
  static BoxDecoration statusIconContainer(Color color) => BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(radiusMedium),
      );

  // GPS card com sinal
  static BoxDecoration gpsCard({required bool hasGps}) => BoxDecoration(
        color: hasGps
            ? AppColors.primary.withValues(alpha: 0.03)
            : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(
          color: hasGps
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.divider,
          width: 1.5,
        ),
      );

  // Coordenada individual
  static BoxDecoration get coordBox => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radiusSmall),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.08)),
      );

  // Botão avatar do usuário
  static BoxDecoration userAvatar({required bool active}) => BoxDecoration(
        color: active ? AppColors.primary : AppColors.primaryBg,
        shape: BoxShape.circle,
      );

  // Dropdown menu
  static BoxDecoration get dropdownMenu => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(color: AppColors.divider),
        boxShadow: menuShadow,
      );

  // Botão voltar circular (header de cadastro)
  static BoxDecoration get backButton => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      );
}
