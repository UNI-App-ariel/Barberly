import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/datasources/appointments_data_source.dart';
import 'package:uni_app/core/common/data/models/appointment_model.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';

/// AppointmentsRepoIml is the implementation of AppointmentsRepo
///
/// It uses AppointmentsDataSource to get the data from the data source
/// and map it to the entities
///
/// Parameters:
/// - [appointmentsDataSource] is the data source instance
class AppointmentsRepoIml implements AppointmentsRepo {
  final AppointmentsDataSource appointmentsDataSource;

  AppointmentsRepoIml({required this.appointmentsDataSource});

  /// getAppointments is a method to get the appointments of a user
  ///
  /// Parameters:
  /// - [userId] is the `id` of the user
  ///
  /// Returns:
  /// - `Stream<Either<Failure, List<Appointment>>>` is a stream of `Either`
  ///   - `Right` contains the list of appointments
  ///   - `Left` contains the failure
  @override
  Stream<Either<Failure, List<Appointment>>> getAppointments(
      String userId) async* {
    try {
      final appointments = appointmentsDataSource.getAppointments(userId);
      // map the stream of List<AppointmentModel> to List<Appointment>
      yield* appointments.map((appointments) {
        return Right(appointments.map((e) => e.toEntity()).toList());
      });
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  /// bookAppointment is a method to book an appointment
  ///
  /// Parameters:
  /// - [appointment] is the appointment to book
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure
  @override
  Future<Either<Failure, void>> bookAppointment(Appointment appointment) async {
    try {
      await appointmentsDataSource
          .bookAppointment(AppointmentModel.fromEntity(appointment));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// cancelAppointment is a method to cancel an appointment
  ///
  /// Parameters:
  /// - [appointmentId] is the `id` of the appointment
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure
  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId) async {
    try {
      appointmentsDataSource.cancelAppointment(appointmentId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// updateAppointment is a method to update an appointment
  ///
  /// Parameters:
  /// - [appointment] is the appointment to update
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure
  @override
  Future<Either<Failure, void>> updateAppointment(
      Appointment appointment) async {
    try {
      await appointmentsDataSource
          .updateAppointment(AppointmentModel.fromEntity(appointment));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
