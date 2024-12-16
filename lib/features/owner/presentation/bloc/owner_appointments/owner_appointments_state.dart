part of 'owner_appointments_bloc.dart';

@immutable
sealed class OwnerAppointmentsState {}

final class OwnerAppointmentsInitial extends OwnerAppointmentsState {}

final class OwnerAppointmentsLoading extends OwnerAppointmentsState {}

final class OwnerAppointmentsLoaded extends OwnerAppointmentsState {
  final List<Appointment> appointments;

  OwnerAppointmentsLoaded(this.appointments);
}

final class OwnerAppointmentsError extends OwnerAppointmentsState {
  final String message;

  OwnerAppointmentsError(this.message);
}
