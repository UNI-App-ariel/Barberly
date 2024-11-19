import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class SignUpWithEmailUseCase
    implements UseCase<MyUser?, SignupWithEmailParams> {
  final AuthRepo _authRepository;

  SignUpWithEmailUseCase(this._authRepository);

  @override
  Future<Either<Failure, MyUser?>> call(SignupWithEmailParams params) async {
    return await _authRepository.signUpWithEmail(
        params.name, params.email, params.password);
  }
}

class SignupWithEmailParams {
  final String name;
  final String email;
  final String password;

  SignupWithEmailParams(
      {required this.name, required this.email, required this.password});
}
