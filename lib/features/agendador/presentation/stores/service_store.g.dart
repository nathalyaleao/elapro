// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceStore on _ServiceStoreBase, Store {
  late final _$servicesAtom =
      Atom(name: '_ServiceStoreBase.services', context: context);

  @override
  ObservableList<Service> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(ObservableList<Service> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  late final _$_ServiceStoreBaseActionController =
      ActionController(name: '_ServiceStoreBase', context: context);

  @override
  void addService(
      {required String name,
      required double price,
      required int durationMinutes}) {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
        name: '_ServiceStoreBase.addService');
    try {
      return super.addService(
          name: name, price: price, durationMinutes: durationMinutes);
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeService(String id) {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
        name: '_ServiceStoreBase.removeService');
    try {
      return super.removeService(id);
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
services: ${services}
    ''';
  }
}
