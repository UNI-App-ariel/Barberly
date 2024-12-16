part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentLoading extends AppointmentState {}


final class AppointmentInitial extends AppointmentState {}

final class AppointmentBooked extends AppointmentState {
  final Appointment appointment;

  AppointmentBooked(this.appointment);
}

final class AppointmentFailure extends AppointmentState {
  final String message;

  AppointmentFailure(this.message);
}
