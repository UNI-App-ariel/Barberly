import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/availability.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for streaming availability data.
class StreamAvailabilityUseCase implements StreamUseCase<Availability, String> {
  final BarbershopRepo repository; // Repository for managing barbershop data

  /// Creates a new instance of [StreamAvailabilityUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  StreamAvailabilityUseCase(this.repository);

  /// Streams availability data based on the provided parameters.
  ///
  /// Returns a [Stream] of [Either<Failure, Availability>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [Availability] is the data being streamed.
  @override
  Stream<Either<Failure, Availability>> call(String params) async* {
    yield* repository.streamAvailabilty(params);
  }
}
