import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class SignInWithEmailUseCase implements UseCase<MyUser?, SinginWithEmailParams> {
  final AuthRepo _authRepo;

  SignInWithEmailUseCase(this._authRepo);

  @override
  Future<Either<Failure, MyUser?>> call(SinginWithEmailParams params) async {
    return await _authRepo.loginWithEmail(params.email, params.password);
  }
}

class SinginWithEmailParams {
  final String email;
  final String password;

  SinginWithEmailParams({required this.email, required this.password});
}
