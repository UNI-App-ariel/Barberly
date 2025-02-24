import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/availability.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for updating availability data.
class UpdateAvailabilityUsecase implements UseCase<void, Availability> {
  final BarbershopRepo repository; // Repository for managing barbershop data

  /// Creates a new instance of [UpdateAvailabilityUsecase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  UpdateAvailabilityUsecase({required this.repository});

  /// Updates the availability data with the provided [Availability] object.
  ///
  /// Returns a [Future] of [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [void] indicates successful completion with no data returned.
  @override
  Future<Either<Failure, void>> call(Availability params) async {
    return await repository.updateAvailability(params);
  }
}
