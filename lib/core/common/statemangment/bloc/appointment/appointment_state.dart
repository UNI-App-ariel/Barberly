part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentLoaded(this.appointments);
}

final class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError(this.message);
}

final class AppointmentBooked extends AppointmentState {
  final Appointment appointment;

  AppointmentBooked(this.appointment);
}

final class AppointmentFailure extends AppointmentState {
  final String message;

  AppointmentFailure(this.message);
}
