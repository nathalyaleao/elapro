import '../../features/agendador/presentation/stores/client_store.dart';
import '../../features/agendador/presentation/stores/service_store.dart';
import '../../features/agendador/presentation/stores/schedule_store.dart';
import '../../features/agendador/presentation/stores/finance_store.dart';

class Injection {
  static final clientStore = ClientStore();
  static final serviceStore = ServiceStore();
  static final scheduleStore = ScheduleStore();
  static final financeStore = FinanceStore();
}
