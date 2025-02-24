import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class AppointmentsRepo {
  /// getAppointments is a method to get the appointments of a user
  ///
  /// Parameters:
  /// - [userId] is the `id` of the user
  ///
  /// Returns:
  /// - `Stream<Either<Failure, List<Appointment>>>` is a stream of `Either`
  ///   - `Right` contains the list of appointments
  ///   - `Left` contains the failure
  Stream<Either<Failure, List<Appointment>>> getAppointments(String userId);

  /// bookAppointment is a method to book an appointment
  ///
  /// Parameters:
  /// - [appointment] is the appointment to book
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure
  Future<Either<Failure, void>> bookAppointment(Appointment appointment);

  /// cancelAppointment is a method to cancel an appointment
  ///
  /// Parameters:
  /// - [appointmentId] is the `id` of the appointment
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure
  Future<Either<Failure, void>> cancelAppointment(String appointmentId);

  /// updateAppointment is a method to update an appointment
  ///
  /// Parameters:
  /// - [appointment] is the appointment to update
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure
  Future<Either<Failure, void>> updateAppointment(Appointment appointment);
}
