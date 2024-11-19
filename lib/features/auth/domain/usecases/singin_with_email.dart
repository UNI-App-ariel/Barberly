import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class SinginWithEmailUsecase implements UseCase<void, SinginWithEmailParams> {
  final AuthRepo _authRepo;

  SinginWithEmailUsecase(this._authRepo);

  @override
  Future<Either<Failure, void>> call(SinginWithEmailParams params) async {
    return await _authRepo.loginWithEmail(params.email, params.password);
  }
}

class SinginWithEmailParams {
  final String email;
  final String password;

  SinginWithEmailParams({required this.email, required this.password});
}
