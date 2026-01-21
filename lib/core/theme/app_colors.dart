import 'package:flutter/material.dart';

class AppColors {
  // Cores Principais
  static const Color primary = Color(0xFFE91E63); // Rosa vibrante
  static const Color secondary = Color(0xFFFCE4EC); // Rosa claro (fundo, cards)
  static const Color accent = Color(0xFFFF4081); // Rosa acento

  // Cores Neutras
  static const Color natureWhite = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA); // Off-white quase branco
  static const Color surface = Color(0xFFFFFFFF);
  
  // Texto
  static const Color textPrimary = Color(0xFF1E1E1E); // Preto suave
  static const Color textSecondary = Color(0xFF757575); // Cinza
  static const Color textLight = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFD32F2F);
  
  // Gradientes (se necessário)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
