import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';
import 'package:elapro/features/agendador/presentation/screens/agendador_dashboard.dart';
import 'package:elapro/features/orcamentista/presentation/screens/orcamentista_dashboard.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  String? _selectedProfile; // 'prestadora' ou 'vendedora'

  void _onConfirm() {
    if (_selectedProfile == 'prestadora') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AgendadorDashboard()),
      );
    } else if (_selectedProfile == 'vendedora') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrcamentistaDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Seleção de Perfil', style: TextStyle(fontSize: 18)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Seja bem-vinda ao ElaPro!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Escolha a opção que melhor descreve o seu negócio para personalizarmos sua experiência de gestão.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Card Prestadora
                    _ProfileCard(
                      title: 'Sou Prestadora de Serviços',
                      description: 'Ideal para quem trabalha com horários marcados e serviços presenciais ou online.',
                      highlightText: 'FOCO EM AGENDAMENTOS',
                      isSelected: _selectedProfile == 'prestadora',
                      imageIcon: Icons.calendar_month, // Placeholder para imagem
                      onTap: () => setState(() => _selectedProfile = 'prestadora'),
                    ),

                    const SizedBox(height: 24),

                    // Card Vendedora
                    _ProfileCard(
                      title: 'Vendo Produtos/Projetos',
                      description: 'Perfeito para quem cria orçamentos personalizados e vende itens físicos ou digitais.',
                      highlightText: 'FOCO EM ORÇAMENTOS',
                      isSelected: _selectedProfile == 'vendedora',
                      imageIcon: Icons.receipt_long, // Placeholder
                      onTap: () => setState(() => _selectedProfile = 'vendedora'),
                    ),
                    
                    const SizedBox(height: 100), // Espaço para botão flutuante
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedProfile != null ? _onConfirm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedProfile != null ? AppColors.primary : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirmar e Continuar', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final String description;
  final String highlightText;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData imageIcon;

  const _ProfileCard({
    required this.title,
    required this.description,
    required this.highlightText,
    required this.isSelected,
    required this.onTap,
    required this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120, // Simulando área da imagem
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Center(
                child: Icon(imageIcon, size: 60, color: AppColors.primary.withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    highlightText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Selecionar Perfil',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
