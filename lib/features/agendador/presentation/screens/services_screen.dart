import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/custom_button.dart';
import 'package:elapro/features/agendador/data/models/agendador_models.dart';
import 'package:elapro/core/injection/injection.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  void _navigateToAddService() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddServiceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
         title: const Text("Meus Serviços"),
         actions: [
            IconButton(onPressed: _navigateToAddService, icon: const Icon(Icons.add))
         ],
      ),
      body: Observer(
        builder: (_) {
          final services = Injection.serviceStore.services;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.spa, color: AppColors.primaryPink, size: 20),
                  ),
                  title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${service.durationMinutes} min", style: const TextStyle(color: Colors.grey)),
                  trailing: Text("R\$ ${service.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddService,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Novo Serviço", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();

  void _saveService() {
    Injection.serviceStore.addService(
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      durationMinutes: int.tryParse(_durationController.text) ?? 30,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Novo Serviço")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
             _buildInput("Nome do Serviço", "Ex: Corte de Cabelo", _nameController),
             const SizedBox(height: 16),
             Row(
               children: [
                 Expanded(child: _buildInput("Preço (R\$)", "0.00", _priceController, keyboardType: TextInputType.number)),
                 const SizedBox(width: 16),
                 Expanded(child: _buildInput("Duração (min)", "30", _durationController, keyboardType: TextInputType.number)),
               ],
             ),
             const Spacer(),
             CustomButton(text: "Salvar Serviço", onPressed: _saveService),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
          ),
        )
      ],
    );
  }
}
