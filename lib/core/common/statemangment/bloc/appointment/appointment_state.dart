part of 'appointment_bloc.dart';

/// Abstract class representing all appointment-related states.
@immutable
sealed class AppointmentState {}

/// State indicating that an appointment is being loaded.
final class AppointmentLoading extends AppointmentState {}

/// Initial state when no appointment actions have been performed yet.
final class AppointmentInitial extends AppointmentState {}

/// State indicating that an appointment has been successfully booked.
///
/// Contains the [appointment] that was booked.
final class AppointmentBooked extends AppointmentState {
  final Appointment appointment;

  /// Creates an instance of [AppointmentBooked].
  ///
  /// Requires the [appointment] that was booked.
  AppointmentBooked(this.appointment);
}

/// State indicating that an appointment action failed.
///
/// Contains the [message] explaining the failure reason.
final class AppointmentFailure extends AppointmentState {
  final String message;

  /// Creates an instance of [AppointmentFailure].
  ///
  /// Requires a [message] describing the failure.
  AppointmentFailure(this.message);
}
