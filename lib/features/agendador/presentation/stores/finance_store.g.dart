// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FinanceStore on _FinanceStoreBase, Store {
  late final _$debitTaxAtom =
      Atom(name: '_FinanceStoreBase.debitTax', context: context);

  @override
  double get debitTax {
    _$debitTaxAtom.reportRead();
    return super.debitTax;
  }

  @override
  set debitTax(double value) {
    _$debitTaxAtom.reportWrite(value, super.debitTax, () {
      super.debitTax = value;
    });
  }

  late final _$creditTaxAtom =
      Atom(name: '_FinanceStoreBase.creditTax', context: context);

  @override
  double get creditTax {
    _$creditTaxAtom.reportRead();
    return super.creditTax;
  }

  @override
  set creditTax(double value) {
    _$creditTaxAtom.reportWrite(value, super.creditTax, () {
      super.creditTax = value;
    });
  }

  late final _$pixTaxAtom =
      Atom(name: '_FinanceStoreBase.pixTax', context: context);

  @override
  double get pixTax {
    _$pixTaxAtom.reportRead();
    return super.pixTax;
  }

  @override
  set pixTax(double value) {
    _$pixTaxAtom.reportWrite(value, super.pixTax, () {
      super.pixTax = value;
    });
  }

  late final _$totalGrossRevenueAtom =
      Atom(name: '_FinanceStoreBase.totalGrossRevenue', context: context);

  @override
  double get totalGrossRevenue {
    _$totalGrossRevenueAtom.reportRead();
    return super.totalGrossRevenue;
  }

  @override
  set totalGrossRevenue(double value) {
    _$totalGrossRevenueAtom.reportWrite(value, super.totalGrossRevenue, () {
      super.totalGrossRevenue = value;
    });
  }

  late final _$totalNetRevenueAtom =
      Atom(name: '_FinanceStoreBase.totalNetRevenue', context: context);

  @override
  double get totalNetRevenue {
    _$totalNetRevenueAtom.reportRead();
    return super.totalNetRevenue;
  }

  @override
  set totalNetRevenue(double value) {
    _$totalNetRevenueAtom.reportWrite(value, super.totalNetRevenue, () {
      super.totalNetRevenue = value;
    });
  }

  late final _$_FinanceStoreBaseActionController =
      ActionController(name: '_FinanceStoreBase', context: context);

  @override
  void setTaxes(
      {required double debit, required double credit, required double pix}) {
    final _$actionInfo = _$_FinanceStoreBaseActionController.startAction(
        name: '_FinanceStoreBase.setTaxes');
    try {
      return super.setTaxes(debit: debit, credit: credit, pix: pix);
    } finally {
      _$_FinanceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void recordPayment(double amount, String method) {
    final _$actionInfo = _$_FinanceStoreBaseActionController.startAction(
        name: '_FinanceStoreBase.recordPayment');
    try {
      return super.recordPayment(amount, method);
    } finally {
      _$_FinanceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
debitTax: ${debitTax},
creditTax: ${creditTax},
pixTax: ${pixTax},
totalGrossRevenue: ${totalGrossRevenue},
totalNetRevenue: ${totalNetRevenue}
    ''';
  }
}
