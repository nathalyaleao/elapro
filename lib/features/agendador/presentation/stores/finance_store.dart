import 'package:mobx/mobx.dart';

part 'finance_store.g.dart';

class FinanceStore = _FinanceStoreBase with _$FinanceStore;

abstract class _FinanceStoreBase with Store {
  @observable
  double debitTax = 1.99; // %

  @observable
  double creditTax = 3.99; // %

  @observable
  double pixTax = 0.0; // %

  @observable
  double totalGrossRevenue = 0.0;

  @observable
  double totalNetRevenue = 0.0;

  @action
  void setTaxes({required double debit, required double credit, required double pix}) {
    debitTax = debit;
    creditTax = credit;
    pixTax = pix;
  }

  @action
  void recordPayment(double amount, String method) {
    double tax = 0.0;
    if (method == 'Débito') tax = debitTax;
    else if (method == 'Crédito') tax = creditTax;
    else if (method == 'Pix') tax = pixTax;

    double netAmount = amount * (1 - (tax / 100));
    
    totalGrossRevenue += amount;
    totalNetRevenue += netAmount;
    
    // TODO: Persist transaction
  }
}
