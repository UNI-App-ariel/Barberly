import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for streaming appointments for a specific barbershop owner.
class GetOwnerAppointmentsStreamsUseCase
    implements StreamUseCase<List<Appointment>, String> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [GetOwnerAppointmentsStreamsUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  GetOwnerAppointmentsStreamsUseCase({required this.barbershopRepo});

  /// Streams a list of appointments for the specified owner.
  ///
  /// Returns a [Stream] of [Either<Failure, List<Appointment>>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [List<Appointment>] contains the streamed list of appointments if successful.
  @override
  Stream<Either<Failure, List<Appointment>>> call(String params) async* {
    yield* barbershopRepo.getAppointmentsStream(params);
  }
}
