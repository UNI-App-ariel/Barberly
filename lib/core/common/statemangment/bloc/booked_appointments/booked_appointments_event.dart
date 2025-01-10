part of 'booked_appointments_bloc.dart';

@immutable
sealed class BookedAppointmentsEvent {}

// get booked appointments
class GetBookedAppointments extends BookedAppointmentsEvent {
  final String userId;

  GetBookedAppointments(this.userId);
}
