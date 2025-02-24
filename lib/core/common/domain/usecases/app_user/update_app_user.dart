import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

/// A use case for updating the application user data.
class UpdateAppUserUseCase implements UseCase<void, UpdateAppUserParams> {
  final AppUserRepo repo; // Repository for accessing user data

  /// Creates a new instance of [UpdateAppUserUseCase].
  ///
  /// Requires an instance of [AppUserRepo] to be provided.
  UpdateAppUserUseCase({required this.repo});

  /// Updates the application user with the provided parameters.
  ///
  /// Returns a [Future] that resolves to [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - `void` indicates successful completion of the update.
  @override
  Future<Either<Failure, void>> call(UpdateAppUserParams params) async {
    return await repo.updateUser(params.user, params.pfp);
  }
}

/// Parameters required to update the application user.
class UpdateAppUserParams {
  final MyUser user; // The user object to be updated
  final File? pfp; // Optional profile picture file

  /// Creates a new instance of [UpdateAppUserParams].
  ///
  /// Requires a [MyUser] object and an optional profile picture file.
  UpdateAppUserParams({required this.user, this.pfp});
}
