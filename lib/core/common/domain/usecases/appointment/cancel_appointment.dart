import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for canceling an appointment.
class CancelAppointmentUseCase implements UseCase<void, String> {
  final AppointmentsRepo
      appointmentsRepo; // Repository for managing appointments

  /// Creates a new instance of [CancelAppointmentUseCase].
  ///
  /// Requires an instance of [AppointmentsRepo] to be provided.
  CancelAppointmentUseCase({required this.appointmentsRepo});

  /// Cancels an appointment using the provided appointment ID.
  ///
  /// Returns a [Future] that resolves to [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - `void` indicates successful cancellation of the appointment.
  @override
  Future<Either<Failure, void>> call(String params) async {
    return appointmentsRepo.cancelAppointment(params);
  }
}
