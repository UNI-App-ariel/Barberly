import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDatasource _authDatasource;

  AuthRepoImpl(this._authDatasource);

  /// Retrieves the current user from the authentication datasource.
  ///
  /// Returns an [Either] containing a [Failure] on error or the current [MyUser] instance.
  @override
  Future<Either<Failure, MyUser?>> getCurrentUser() async {
    try {
      final user = await _authDatasource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  /// Logs in a user with the provided email and password.
  ///
  /// Returns an [Either] containing a [Failure] on error or the logged-in [MyUser] instance.
  @override
  Future<Either<Failure, MyUser?>> loginWithEmail(
      String email, String password) async {
    try {
      final user = await _authDatasource.loginWithEmail(email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  /// Logs out the current user.
  ///
  /// Returns an [Either] containing a [Failure] on error or null if successful.
  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await _authDatasource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  /// Signs up a new user with the provided name, email, and password.
  ///
  /// Returns an [Either] containing a [Failure] on error or the signed-up [MyUser] instance.
  @override
  Future<Either<Failure, MyUser?>> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await _authDatasource.signUpWithEmail(name, email, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  /// Signs in a user with Google authentication.
  ///
  /// Returns an [Either] containing a [Failure] on error or the signed-in [MyUser] instance.
  @override
  Future<Either<Failure, MyUser?>> signInWithGoogle() async {
    try {
      final user = await _authDatasource.signInWithGoogle();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  /// Signs in a user with Facebook authentication.
  ///
  /// Returns an [Either] containing a [Failure] on error or the signed-in [MyUser] instance.
  @override
  Future<Either<Failure, MyUser?>> signInWithFacebook() async {
    try {
      final user = await _authDatasource.signInWithFacebook();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
