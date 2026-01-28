import 'package:mobx/mobx.dart';
import '../../data/models/agendador_models.dart';

part 'client_store.g.dart';

class ClientStore = _ClientStoreBase with _$ClientStore;

abstract class _ClientStoreBase with Store {
  @observable
  ObservableList<Client> clients = ObservableList<Client>();

  @observable
  bool isLoading = false;

  @observable
  String searchQuery = '';

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void addClient(Client client) {
    clients.add(client);
    // TODO: Persist to Firebase
  }

  @action
  Client quickCreateClient(String name, String whatsapp, {String? address, String? cpf, DateTime? birthday, String? email, String? notes}) {
    final newClient = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString() + name.length.toString(),
      name: name,
      phone: whatsapp,
      lastVisit: DateTime.now(),
      address: address,
      cpf: cpf,
      birthday: birthday,
      email: email,
      notes: notes,
    );
    addClient(newClient);
    return newClient;
  }

  // Versão especial para testes de retenção
  Client quickCreateTestClient(String name, String whatsapp, {String? address, String? cpf, DateTime? birthday, String? email, String? notes, DateTime? lastVisit}) {
    final newClient = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString() + name.length.toString(),
      name: name,
      phone: whatsapp,
      lastVisit: lastVisit ?? DateTime.now(),
      address: address,
      cpf: cpf,
      birthday: birthday,
      email: email,
      notes: notes,
    );
    addClient(newClient);
    return newClient;
  }

  @action
  void updateClient(Client client) {
    final index = clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      clients[index] = client;
    }
  }

  @computed
  List<Client> get filteredClients {
    if (searchQuery.isEmpty) return clients.toList();
    
    final query = _normalize(searchQuery);
    
    return clients.where((c) {
      final normalizedName = _normalize(c.name);
      final normalizedPhone = _normalize(c.phone);
      final normalizedEmail = _normalize(c.email ?? '');
      
      return normalizedName.contains(query) || 
             normalizedPhone.contains(query) || 
             normalizedEmail.contains(query);
    }).toList();
  }

  String _normalize(String text) {
    if (text.isEmpty) return '';
    var normalized = text.toLowerCase();
    
    const withAccent = 'àáâãäåèéêëìíîïòóôõöùúûüçñ';
    const withoutAccent = 'aaaaaaeeeeiiiiooooouuuucn';
    
    for (int i = 0; i < withAccent.length; i++) {
      normalized = normalized.replaceAll(withAccent[i], withoutAccent[i]);
    }
    
    return normalized;
  }
}
