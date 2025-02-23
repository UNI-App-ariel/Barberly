import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class AppointmentsRepo {
  Stream<Either<Failure, List<Appointment>>> getAppointments(String userId);
  Future<Either<Failure, void>> bookAppointment(Appointment appointment);
  Future<Either<Failure, void>> cancelAppointment(String appointmentId);
  Future<Either<Failure, void>> updateAppointment(Appointment appointment);
}
