part of 'booked_appointments_bloc.dart';

@immutable
sealed class BookedAppointmentsState {}

final class BookedAppointmentsInitial extends BookedAppointmentsState {}

final class BookedAppointmentsLoading extends BookedAppointmentsState {}

final class BookedAppointmentsLoaded extends BookedAppointmentsState {
  final List<Appointment> appointments;

  BookedAppointmentsLoaded(this.appointments);
}

final class BookedAppointmentsError extends BookedAppointmentsState {
  final String message;

  BookedAppointmentsError(this.message);
}
