import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/datasources/appointments_data_source.dart';
import 'package:uni_app/core/common/data/models/appointment_model.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';

class AppointmentsRepoIml implements AppointmentsRepo {
  final AppointmentsDataSource appointmentsDataSource;

  AppointmentsRepoIml({required this.appointmentsDataSource});

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

  @override
  Future<Either<Failure, void>> cancelAppointment(String appointmentId) async {
    try {
      appointmentsDataSource.cancelAppointment(appointmentId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

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
