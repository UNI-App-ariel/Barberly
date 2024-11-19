import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDatasource _authDatasource;

  AuthRepoImpl(this._authDatasource);

  @override
  Future<Either<Failure, void>> getCurrentUser() async {
    try {
      final user = await _authDatasource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> loginWithEmail(
      String email, String password) async {
    try {
      await _authDatasource.loginWithEmail(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authDatasource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> registerWithEmail(
      String email, String password) async {
    try {
      await _authDatasource.registerWithEmail(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
