import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class SignupWithEmail implements UseCase<void, SignupWithEmailParams> {
  final AuthRepo _authRepository;

  SignupWithEmail(this._authRepository);

  @override
  Future<Either<Failure, void>> call(SignupWithEmailParams params) async {
    return await _authRepository.signUpWithEmail(params.email, params.password);
  }
}

class SignupWithEmailParams {
  final String email;
  final String password;

  SignupWithEmailParams({required this.email, required this.password});
}
