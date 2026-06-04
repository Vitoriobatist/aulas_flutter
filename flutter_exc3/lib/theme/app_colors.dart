import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primárias
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFF3B82F6);
  static const primaryBg = Color(0xFFEFF6FF);

  // Superfícies
  static const background = Color(0xFFF4F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF8FAFC);

  // Texto
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF1E293B);
  static const textMuted = Color(0xFF475569);
  static const textDisabled = Color(0xFF94A3B8);

  // Bordas / Divisores
  static const divider = Color(0xFFE2E8F0);
  static const dividerLight = Color(0xFFF1F5F9);

  // Status
  static const statusPendente = Color(0xFF64748B);
  static const statusSaiu = Color(0xFFF97316);
  static const statusTransporte = Color(0xFF2563EB);
  static const statusEntregue = Color(0xFF16A34A);

  // Feedback
  static const error = Color(0xFFEF4444);

  static Color statusColor(String status) {
    switch (status) {
      case 'Entregue':
        return statusEntregue;
      case 'Em transporte':
        return statusTransporte;
      case 'Saiu para entrega':
        return statusSaiu;
      default:
        return statusPendente;
    }
  }
}
