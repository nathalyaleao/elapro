import 'package:mobx/mobx.dart';
import '../../data/models/agendador_models.dart';

part 'schedule_store.g.dart';

class ScheduleStore = _ScheduleStoreBase with _$ScheduleStore;

abstract class _ScheduleStoreBase with Store {
  @observable
  ObservableList<Appointment> appointments = ObservableList<Appointment>();

  @observable
  String? errorMessage;

  @action
  bool hasConflict(DateTime start, int durationMinutes) {
    final end = start.add(Duration(minutes: durationMinutes));
    
    for (var app in appointments) {
      final appStart = app.dateTime;
      final appEnd = app.dateTime.add(Duration(minutes: app.service.durationMinutes));
      
      // Check for overlap
      if (start.isBefore(appEnd) && end.isAfter(appStart)) {
        errorMessage = "Horário Ocupado por ${app.client.name}";
        return true;
      }
    }
    
    errorMessage = null;
    return false;
  }

  @action
  bool addAppointment(Appointment appointment) {
    if (hasConflict(appointment.dateTime, appointment.service.durationMinutes)) {
      return false;
    }
    
    appointments.add(appointment);
    return true;
  }
}
