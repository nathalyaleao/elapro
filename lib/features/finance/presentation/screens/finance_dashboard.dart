import 'package:flutter/material.dart';
import 'package:elapro/core/theme/app_colors.dart';
import 'package:elapro/features/finance/data/finance_repository.dart';
import 'expense_form_screen.dart';

class FinanceDashboard extends StatelessWidget {
  const FinanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = FinanceRepository();

    return ValueListenableBuilder<List<Transaction>>(
      valueListenable: repo.transactionsNotifier,
      builder: (context, transactions, child) {
        final income = repo.totalIncome;
        final expense = repo.totalExpense;
        final balance = repo.balance;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text("Financeiro"),
            actions: [
               IconButton(
                 icon: const Icon(Icons.add_circle, color: Colors.red),
                 onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseFormScreen())),
                 tooltip: "Adicionar Despesa",
               )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // 1. Balance Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    children: [
                      const Text("Saldo Atual", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("R\$ ${balance.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _BalanceRowItem(label: "Entradas", value: income, icon: Icons.arrow_upward, color: Colors.greenAccent),
                          Container(width: 1, height: 40, color: Colors.white24),
                          _BalanceRowItem(label: "Saídas", value: expense, icon: Icons.arrow_downward, color: Colors.redAccent),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 2. Simple Chart (Visual Representation)
                const Align(alignment: Alignment.centerLeft, child: Text("Fluxo do Mês", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                Container(
                  height: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Bar(label: "Entradas", value: income, total: income + expense + 1, color: Colors.green),
                      _Bar(label: "Saídas", value: expense, total: income + expense + 1, color: Colors.red),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 3. Transactions List
                const Align(alignment: Alignment.centerLeft, child: Text("Últimas Transações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                ...transactions.map((t) => _TransactionTile(transaction: t)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BalanceRowItem extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;

  const _BalanceRowItem({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
           children: [
             Icon(icon, color: color, size: 16),
             const SizedBox(width: 4),
             Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
           ],
        ),
        const SizedBox(height: 4),
        Text("R\$ ${value.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final double total;
  final Color color;

  const _Bar({required this.label, required this.value, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    // Calculate height percentage (max 100px)
    final height = (value / total) * 100;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("R\$${value.toStringAsFixed(0)}", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: height < 10 ? 10 : height, // Min height
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
               width: 40,
               height: height < 5 ? 5 : height * 0.8, // Fill logic
               decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward, 
              color: isIncome ? Colors.green : Colors.red,
              size: 20
            ), // Income arrow down (into pocket), Expense arrow up (out)? Material design convention varies. Let's stick to Green = Good.
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(transaction.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            "${isIncome ? '+' : '-'} R\$ ${transaction.value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
