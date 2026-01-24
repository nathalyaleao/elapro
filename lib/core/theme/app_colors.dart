import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Oficiais)
  static const Color primaryPink = Color(0xFFEC4899);
  static const Color primaryPurple = Color(0xFF8B5CF6);

  // Degradê oficial
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryPink, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Cores de Apoio (Harmonizadas)
  static const Color background = Color(0xFFF8FAFC);
  static const Color secondary = Color(0xFFFDF2F8); // Rosa-50 clarinho para fundos
  static const Color surface = Color(0xFFFFFFFF);
  static const Color natureWhite = Color(0xFFFFFFFF);
  
  // Texto
  static const Color textPrimary = Color(0xFF1E293B); // Slate-800
  static const Color textSecondary = Color(0xFF64748B); // Slate-500
  static const Color textLight = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  
  // Retrocompatibilidade
  // Apontando 'primary' para o rosa oficial para que componentes existentes se atualizem
  static const Color primary = primaryPink;
  static const Color accent = primaryPurple;
}
