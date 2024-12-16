part of 'appointment_bloc.dart';

@immutable
abstract class AppointmentEvent {}

class BookAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  BookAppointmentEvent(this.appointment);
}

class CancelAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  CancelAppointmentEvent(this.appointment);
}
