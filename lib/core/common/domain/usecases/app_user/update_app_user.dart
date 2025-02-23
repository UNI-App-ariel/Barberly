import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

class UpdateAppUserUseCase implements UseCase<void, UpdateAppUserParams> {
  final AppUserRepo repo;

  UpdateAppUserUseCase({required this.repo});

  @override
  Future<Either<Failure, void>> call(UpdateAppUserParams params) async {
    return await repo.updateUser(params.user, params.pfp);
  }
}

class UpdateAppUserParams {
  final MyUser user;
  final File? pfp;

  UpdateAppUserParams({required this.user, this.pfp});
}
