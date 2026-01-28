// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScheduleStore on _ScheduleStoreBase, Store {
  late final _$appointmentsAtom =
      Atom(name: '_ScheduleStoreBase.appointments', context: context);

  @override
  ObservableList<Appointment> get appointments {
    _$appointmentsAtom.reportRead();
    return super.appointments;
  }

  @override
  set appointments(ObservableList<Appointment> value) {
    _$appointmentsAtom.reportWrite(value, super.appointments, () {
      super.appointments = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ScheduleStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$_ScheduleStoreBaseActionController =
      ActionController(name: '_ScheduleStoreBase', context: context);

  @override
  bool hasConflict(DateTime start, int durationMinutes) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.hasConflict');
    try {
      return super.hasConflict(start, durationMinutes);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool addAppointment(Appointment appointment) {
    final _$actionInfo = _$_ScheduleStoreBaseActionController.startAction(
        name: '_ScheduleStoreBase.addAppointment');
    try {
      return super.addAppointment(appointment);
    } finally {
      _$_ScheduleStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appointments: ${appointments},
errorMessage: ${errorMessage}
    ''';
  }
}
