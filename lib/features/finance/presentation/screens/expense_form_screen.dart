import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/custom_button.dart';
import 'package:elapro/features/finance/data/finance_repository.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  String _selectedCategory = 'Material';

  final List<String> _categories = ['Material', 'Transporte', 'Alimentação', 'Contas', 'Outros'];

  void _saveExpense() {
    if (_titleController.text.isEmpty || _valueController.text.isEmpty) return;

    final value = double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0.0;
    
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: _titleController.text,
      value: value,
      type: TransactionType.expense,
      date: DateTime.now(),
      category: _selectedCategory,
    );

    FinanceRepository().addTransaction(newTransaction);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Despesa registrada com sucesso!"), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Nova Despesa")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text("Onde você gastou?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             const SizedBox(height: 16),
             TextField(
               controller: _titleController,
               decoration: const InputDecoration(
                 labelText: "Descrição (ex: Uber, Algodão)",
                 filled: true, fillColor: Colors.white,
                 border: OutlineInputBorder(),
               ),
             ),
             const SizedBox(height: 16),
             TextField(
               controller: _valueController,
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(
                 labelText: "Valor (R\$)",
                 prefixText: "R\$ ",
                 filled: true, fillColor: Colors.white,
                 border: OutlineInputBorder(),
               ),
             ),
             const SizedBox(height: 16),
             const Text("Categoria", style: TextStyle(fontWeight: FontWeight.bold)),
             const SizedBox(height: 8),
             Wrap(
               spacing: 8,
               children: _categories.map((cat) {
                 final isSelected = _selectedCategory == cat;
                 return ChoiceChip(
                   label: Text(cat),
                   selected: isSelected,
                   selectedColor: Colors.redAccent.withOpacity(0.2),
                   labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black),
                   onSelected: (selected) => setState(() => _selectedCategory = cat),
                 );
               }).toList(),
             ),
             const Spacer(),
             CustomButton(text: "Registrar Saída", onPressed: _saveExpense),
          ],
        ),
      ),
    );
  }
}
