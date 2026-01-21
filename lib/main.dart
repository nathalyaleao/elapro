import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_theme.dart';
import 'package:elapro/features/auth/presentation/screens/login_screen.dart';

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
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
