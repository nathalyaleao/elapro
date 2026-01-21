import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';

class BookingLinkSettingsScreen extends StatefulWidget {
  const BookingLinkSettingsScreen({super.key});

  @override
  State<BookingLinkSettingsScreen> createState() => _BookingLinkSettingsScreenState();
}

class _BookingLinkSettingsScreenState extends State<BookingLinkSettingsScreen> {
  bool _showPrices = true;
  final String _link = "elapro.app/mariasilva";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Link de Agendamento")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Seu cartão de visitas online", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Compartilhe este link na sua bio do Instagram para suas clientes agendarem sozinhas.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _link,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Link copiado para a área de transferência!")),
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            SwitchListTile(
              title: const Text("Mostrar Preços no Link"),
              subtitle: const Text("Se desativado, a cliente vê apenas os serviços."),
              value: _showPrices,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _showPrices = val),
            ),
            const Spacer(),
            CustomButton(
              text: "Ver Link Agora", 
              onPressed: () {},
              icon: Icons.open_in_new,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: "Salvar Configurações", 
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
