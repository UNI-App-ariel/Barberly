import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class GetCurrentUserUseCase implements UseCase<MyUser?, NoParams> {
  final AuthRepo _authRepo;

  GetCurrentUserUseCase(this._authRepo);

  @override
  Future<Either<Failure, MyUser?>> call(NoParams params) async {
    return await _authRepo.getCurrentUser();
  }
}