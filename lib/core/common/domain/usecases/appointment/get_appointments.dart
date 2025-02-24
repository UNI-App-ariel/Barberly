import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for retrieving a list of appointments.
class GetAppointmentsUseCase
    implements StreamUseCase<List<Appointment>, String> {
  final AppointmentsRepo
      appointmentRepo; // Repository for managing appointments

  /// Creates a new instance of [GetAppointmentsUseCase].
  ///
  /// Requires an instance of [AppointmentsRepo] to be provided.
  GetAppointmentsUseCase({required this.appointmentRepo});

  /// Retrieves a stream of appointments based on the provided parameters.
  ///
  /// Returns a [Stream] that yields [Either<Failure, List<Appointment>>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [List<Appointment>] contains the retrieved appointments.
  @override
  Stream<Either<Failure, List<Appointment>>> call(String params) async* {
    yield* appointmentRepo.getAppointments(params);
  }
}
