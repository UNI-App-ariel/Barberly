import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for updating an appointment.
class UpdateAppointmentUseCase implements UseCase<void, Appointment> {
  final AppointmentsRepo repository; // Repository for managing appointments

  /// Creates a new instance of [UpdateAppointmentUseCase].
  ///
  /// Requires an instance of [AppointmentsRepo] to be provided.
  UpdateAppointmentUseCase(this.repository);

  /// Updates the provided appointment.
  ///
  /// Returns a [Future] that resolves to [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - `void` indicates successful completion with no additional value.
  @override
  Future<Either<Failure, void>> call(Appointment params) async {
    return await repository.updateAppointment(params);
  }
}
