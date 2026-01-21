import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';
import 'package:elapro/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('ElaPro'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Comece sua jornada',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crie sua conta e organize seu negócio agora mesmo.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Nome Completo
              const AuthTextField(
                label: 'Nome Completo',
                hint: 'Como deseja ser chamada?',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              
              // Email
              const AuthTextField(
                label: 'E-mail',
                hint: 'exemplo@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              
              // Senha
              AuthTextField(
                label: 'Senha',
                hint: 'Mínimo 8 caracteres',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                isObscure: !_isPasswordVisible,
                onToggleVisibility: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              ),
              const SizedBox(height: 20),

              // Confirmar Senha
              AuthTextField(
                label: 'Confirmar Senha',
                hint: 'Repita sua senha',
                prefixIcon: Icons.refresh, // Icone de loop/refresh como no print
                isPassword: true,
                isObscure: !_isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
              ),

              const SizedBox(height: 24),
              // Termos
              const Text.rich(
                TextSpan(
                  text: 'Ao se cadastrar, você concorda com nossos ',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  children: [
                    TextSpan(
                      text: 'Termos de Uso',
                      style: TextStyle(
                        color: AppColors.primary, 
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' e '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),
              CustomButton(
                text: 'Criar minha conta',
                onPressed: () {
                   // TODO: Implementar cadastro
                },
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),
              
              CustomButton(
                text: 'Cadastrar com Google',
                onPressed: () {},
                isOutlined: true,
                icon: Icons.g_mobiledata,
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já possui uma conta? ',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(), // Volta pro Login
                    child: const Text(
                      'Faça login',
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
