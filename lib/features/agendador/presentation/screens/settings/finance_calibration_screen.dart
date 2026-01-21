import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/common/widgets/custom_button.dart';

class FinanceCalibrationScreen extends StatefulWidget {
  const FinanceCalibrationScreen({super.key});

  @override
  State<FinanceCalibrationScreen> createState() => _FinanceCalibrationScreenState();
}

class _FinanceCalibrationScreenState extends State<FinanceCalibrationScreen> {
  final _goalController = TextEditingController(text: "4000.00");
  final _costsController = TextEditingController(text: "800.00");

  double get _hourlyRate {
    final goal = double.tryParse(_goalController.text) ?? 0;
    final costs = double.tryParse(_costsController.text) ?? 0;
    // Simple math: 160 hours per month (40h/week)
    return (goal + costs) / 160;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Calibragem Financeira")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Ajuste suas metas e custos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Esses valores ajudam o app a calcular quão saudável está seu negócio.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildInput("Minha Meta Mensal (Líquido)", _goalController, prefix: "R\$ "),
            const SizedBox(height: 24),
            _buildInput("Meus Custos Fixos (Aluguel, Luz, etc)", _costsController, prefix: "R\$ "),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text("Sua Hora Técnica Ideal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    "R\$ ${_hourlyRate.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Este é o valor mínimo que você deve cobrar por hora para atingir sua meta.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            CustomButton(text: "Salvar Calibragem", onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: prefix,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          onChanged: (val) => setState(() {}),
        ),
      ],
    );
  }
}
