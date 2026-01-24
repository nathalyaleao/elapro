import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';
import 'package:elapro/features/auth/presentation/widgets/auth_text_field.dart';
import 'register_screen.dart';
import 'package:elapro/features/onboarding/presentation/screens/onboarding_wrapper_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _handleLogin() {
    // Simulating login success
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => const OnboardingFlowScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo do App
              Center(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 50),
              // Ícone do App
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPink.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30), // Arredondamento suave como no ícone
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Bem-vinda de volta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700, // Slightly less heavy than bold
                  color: AppColors.textPrimary,
                  letterSpacing: -1.0, // Tighter titles look more premium
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sua jornada empreendedora continua aqui.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  letterSpacing: -0.2, // Subtle tightening for refinement
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              AuthTextField(
                label: 'E-mail',
                hint: 'exemplo@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: 'Senha',
                hint: 'Sua senha secreta',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                isObscure: !_isPasswordVisible,
                onToggleVisibility: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              CustomButton(
                text: 'Entrar',
                onPressed: _handleLogin,
              ),
              
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou continue com',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 32),
              
              CustomButton(
                text: 'Entrar com Google',
                onPressed: () {},
                isOutlined: true,
                icon: Icons.g_mobiledata, // Placeholder
              ),
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ainda não tem uma conta? ',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  GestureDetector(
                    onTap: _navigateToRegister,
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
