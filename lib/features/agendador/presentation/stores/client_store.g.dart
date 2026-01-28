// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClientStore on _ClientStoreBase, Store {
  Computed<List<Client>>? _$filteredClientsComputed;

  @override
  List<Client> get filteredClients => (_$filteredClientsComputed ??=
          Computed<List<Client>>(() => super.filteredClients,
              name: '_ClientStoreBase.filteredClients'))
      .value;

  late final _$clientsAtom =
      Atom(name: '_ClientStoreBase.clients', context: context);

  @override
  ObservableList<Client> get clients {
    _$clientsAtom.reportRead();
    return super.clients;
  }

  @override
  set clients(ObservableList<Client> value) {
    _$clientsAtom.reportWrite(value, super.clients, () {
      super.clients = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ClientStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: '_ClientStoreBase.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$_ClientStoreBaseActionController =
      ActionController(name: '_ClientStoreBase', context: context);

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
        name: '_ClientStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addClient(Client client) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
        name: '_ClientStoreBase.addClient');
    try {
      return super.addClient(client);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Client quickCreateClient(String name, String whatsapp,
      {String? address,
      String? cpf,
      DateTime? birthday,
      String? email,
      String? notes}) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
        name: '_ClientStoreBase.quickCreateClient');
    try {
      return super.quickCreateClient(name, whatsapp,
          address: address,
          cpf: cpf,
          birthday: birthday,
          email: email,
          notes: notes);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateClient(Client client) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
        name: '_ClientStoreBase.updateClient');
    try {
      return super.updateClient(client);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
clients: ${clients},
isLoading: ${isLoading},
searchQuery: ${searchQuery},
filteredClients: ${filteredClients}
    ''';
  }
}
