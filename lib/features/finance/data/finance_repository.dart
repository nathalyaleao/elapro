import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double value;
  final TransactionType type;
  final DateTime date;
  final String category; // e.g., "Serviço", "Material", "Transporte"

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.type,
    required this.date,
    required this.category,
  });
}

// Simple Singleton Service to hold state in memory for the session
class FinanceRepository {
  static final FinanceRepository _instance = FinanceRepository._internal();
  factory FinanceRepository() => _instance;
  FinanceRepository._internal();

  final ValueNotifier<List<Transaction>> transactionsNotifier = ValueNotifier([
    // Mock Initial Data
    Transaction(id: '1', title: 'Manicure Maria', value: 45.0, type: TransactionType.income, date: DateTime.now().subtract(const Duration(days: 1)), category: 'Serviço'),
    Transaction(id: '2', title: 'Uber Material', value: 15.0, type: TransactionType.expense, date: DateTime.now().subtract(const Duration(days: 2)), category: 'Transporte'),
    Transaction(id: '3', title: 'Esmaltes Novos', value: 80.0, type: TransactionType.expense, date: DateTime.now().subtract(const Duration(days: 3)), category: 'Material'),
    Transaction(id: '4', title: 'Sobrancelha Ana', value: 35.0, type: TransactionType.income, date: DateTime.now(), category: 'Serviço'),
  ]);

  void addTransaction(Transaction t) {
    final currentList = List<Transaction>.from(transactionsNotifier.value);
    currentList.insert(0, t); // Add to top
    transactionsNotifier.value = currentList;
  }

  double get totalIncome => transactionsNotifier.value
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.value);

  double get totalExpense => transactionsNotifier.value
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.value);
      
  double get balance => totalIncome - totalExpense;
}
