import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';

class BrandSettingsScreen extends StatefulWidget {
  const BrandSettingsScreen({super.key});

  @override
  State<BrandSettingsScreen> createState() => _BrandSettingsScreenState();
}

class _BrandSettingsScreenState extends State<BrandSettingsScreen> {
  final _nameController = TextEditingController(text: "Studio Maria Silva");
  final _bioController = TextEditingController(text: "Realçando sua beleza desde 2015");
  final _addressController = TextEditingController(text: "Rua das Flores, 123");
  bool _isAtHome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Identidade da Marca")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026024d'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildInput("Nome do Espaço", _nameController),
            const SizedBox(height: 16),
            _buildInput("Biografia Curta", _bioController, maxLines: 2),
            const SizedBox(height: 24),
            const Text("Localização", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text("Atendo a Domicílio"),
              value: _isAtHome,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isAtHome = val),
            ),
            if (!_isAtHome) ...[
              const SizedBox(height: 16),
              _buildInput("Endereço", _addressController),
            ],
            const SizedBox(height: 48),
            CustomButton(text: "Salvar Alterações", onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
