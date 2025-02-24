import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';

/// An abstract interface class representing a use case with a single execution method
/// that returns a future result.
abstract interface class UseCase<SuccessType, Params> {
  /// Executes the use case with the given [params].
  ///
  /// Returns an [Either] type, where the left side is a [Failure] and the right side
  /// is of type [SuccessType]. The caller must handle both success and failure cases.
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// An abstract interface class representing a use case that returns a stream of results.
abstract interface class StreamUseCase<SuccessType, Params> {
  /// Executes the use case with the given [params].
  ///
  /// Returns a [Stream] of [Either] types, where the left side is a [Failure] and the right side
  /// is of type [SuccessType]. The caller must handle both success and failure cases.
  Stream<Either<Failure, SuccessType>> call(Params params);
}

/// A class representing an empty parameter case, used when a use case does not require any parameters.
class NoParams {}
