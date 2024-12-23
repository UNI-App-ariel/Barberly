
import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

class UpdateAppUserUseCase implements UseCase<void, MyUser> {
  final AppUserRepo repo;

  UpdateAppUserUseCase({required this.repo});

  @override
  Future<Either<Failure, void>> call(MyUser params) async {
    return await repo.updateUser(params);
  }


}