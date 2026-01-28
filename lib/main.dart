import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/features/agendador/presentation/screens/agendador_dashboard.dart';

void main() {
  runApp(const ElaProApp());
}

class ElaProApp extends StatelessWidget {
  const ElaProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElaPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPink,
          primary: AppColors.primaryPink,
          secondary: AppColors.primaryPurple,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      // ATALHO PARA TESTES: Pulando Splash e Onboarding
      home: const AgendadorDashboard(),
    );
  }
}
