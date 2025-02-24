part of 'appointment_bloc.dart';

/// Abstract class representing all appointment-related events.
@immutable
abstract class AppointmentEvent {}

/// Event to book an appointment.
///
/// Contains the [appointment] that is to be booked.
class BookAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  /// Creates an instance of [BookAppointmentEvent].
  ///
  /// Requires an [appointment] to be booked.
  BookAppointmentEvent(this.appointment);
}

/// Event to cancel an appointment.
///
/// Contains the [appointment] that is to be canceled.
class CancelAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  /// Creates an instance of [CancelAppointmentEvent].
  ///
  /// Requires an [appointment] to be canceled.
  CancelAppointmentEvent(this.appointment);
}
