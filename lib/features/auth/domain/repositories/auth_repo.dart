import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, void>> loginWithEmail(String email, String password);
  Future<Either<Failure, void>> registerWithEmail(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> getCurrentUser();
}
