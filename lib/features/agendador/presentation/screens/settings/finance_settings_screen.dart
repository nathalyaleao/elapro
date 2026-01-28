import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/core/injection/injection.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FinanceSettingsScreen extends StatefulWidget {
  const FinanceSettingsScreen({super.key});

  @override
  State<FinanceSettingsScreen> createState() => _FinanceSettingsScreenState();
}

class _FinanceSettingsScreenState extends State<FinanceSettingsScreen> {
  final _debitController = TextEditingController();
  final _creditController = TextEditingController();
  final _pixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _debitController.text = Injection.financeStore.debitTax.toString();
    _creditController.text = Injection.financeStore.creditTax.toString();
    _pixController.text = Injection.financeStore.pixTax.toString();
  }

  void _save() {
    Injection.financeStore.setTaxes(
      debit: double.tryParse(_debitController.text) ?? 0.0,
      credit: double.tryParse(_creditController.text) ?? 0.0,
      pix: double.tryParse(_pixController.text) ?? 0.0,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Configurações financeiras salvas!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Taxas da Maquininha")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Configure as taxas que você paga por venda para calcularmos o seu lucro real.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _buildTaxInput("Taxa Débito (%)", _debitController),
            const SizedBox(height: 20),
            _buildTaxInput("Taxa Crédito (%)", _creditController),
            const SizedBox(height: 20),
            _buildTaxInput("Taxa Pix (%)", _pixController),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Salvar Taxas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixText: "%",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
