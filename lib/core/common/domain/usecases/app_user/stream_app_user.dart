import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

/// A use case for streaming the application user data.
class StreamAppUserUseCase implements StreamUseCase<MyUser?, String> {
  final AppUserRepo repo; // Repository for accessing user data

  /// Creates a new instance of [StreamAppUserUseCase].
  ///
  /// Requires an instance of [AppUserRepo] to be provided.
  StreamAppUserUseCase({required this.repo});

  /// Streams the user data based on the provided [params].
  ///
  /// Returns a stream of [Either<Failure, MyUser?>] where:
  /// - [Failure] represents an error if one occurs,
  /// - [MyUser?] is the user object or null if not found.
  @override
  Stream<Either<Failure, MyUser?>> call(String params) async* {
    yield* repo.getUserStream(params);
  }
}
