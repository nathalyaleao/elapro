import 'package:mobx/mobx.dart';
import '../../data/models/agendador_models.dart';

part 'service_store.g.dart';

class ServiceStore = _ServiceStoreBase with _$ServiceStore;

abstract class _ServiceStoreBase with Store {
  @observable
  ObservableList<Service> services = ObservableList<Service>();

  @action
  void addService({required String name, required double price, required int durationMinutes}) {
    final service = Service(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      durationMinutes: durationMinutes,
    );
    services.add(service);
  }

  @action
  void removeService(String id) {
    services.removeWhere((s) => s.id == id);
  }
}
