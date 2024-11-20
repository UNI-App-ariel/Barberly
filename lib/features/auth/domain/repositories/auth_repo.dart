import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, MyUser?>> loginWithEmail(
      String email, String password);
  Future<Either<Failure, MyUser?>> signUpWithEmail(
      String name, String email, String password);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, MyUser?>> getCurrentUser();
  Future<Either<Failure, MyUser?>> signInWithGoogle();
}
