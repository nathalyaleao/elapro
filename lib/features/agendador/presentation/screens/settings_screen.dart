import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/features/agendador/presentation/screens/services_screen.dart';
import 'package:elapro/features/auth/presentation/screens/login_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/settings/brand_settings_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/settings/availability_settings_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/settings/finance_calibration_screen.dart';
import 'package:elapro/features/agendador/presentation/screens/settings/booking_link_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Configurações"),
        centerTitle: true,
        automaticallyImplyLeading: false, // Inside Dashboard, usually no back button
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader("O MEU NEGÓCIO"),
          _buildSettingsTile(
            icon: Icons.storefront_outlined,
            title: "Identidade da Marca",
            subtitle: "Logo, nome e endereço",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BrandSettingsScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.calendar_month_outlined,
            title: "Minha Disponibilidade",
            subtitle: "Horários e dias de trabalho",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AvailabilitySettingsScreen()));
            },
          ),
          _buildSettingsTile(
            icon: Icons.spa_outlined,
            title: "Meus Serviços",
            subtitle: "Gerenciar cardápio e preços",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("FINANCEIRO"),
          _buildSettingsTile(
            icon: Icons.calculate_outlined,
            title: "Calibragem Financeira",
            subtitle: "Metas e custos fixos",
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => const FinanceCalibrationScreen()));
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("CLIENTES & AGENDAMENTO"),
          _buildSettingsTile(
            icon: Icons.link,
            title: "Link de Agendamento",
            subtitle: "Configurar seu site de agendamento",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingLinkSettingsScreen()));
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("APLICATIVO"),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: "Fale Conosco",
            subtitle: "Suporte via WhatsApp",
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Abrindo suporte por WhatsApp...")),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.logout,
            title: "Sair do App",
            titleColor: Colors.red,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryPurple,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color titleColor = Colors.black,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: titleColor == Colors.red ? Colors.red : AppColors.primaryPink),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
    );
  }
}
