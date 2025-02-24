import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/datasources/app_user_datasource.dart';
import 'package:uni_app/core/common/domain/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/auth/data/models/user_model.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

/// AppUserRepoImpl is the implementation of AppUserRepo
///
/// It uses AppUserDatasource to get the data from the server
///
/// Parameters:
/// - [datasource]: is the datasource instance
class AppUserRepoImpl implements AppUserRepo {
  final AppUserDatasource datasource;

  AppUserRepoImpl({required this.datasource});

  /// getUserStream is a method that returns a stream of user data
  ///
  /// Parameters:
  /// - [userId]: is the user id
  ///
  /// Returns:
  /// - `Stream<Either<Failure, MyUserModel?>>`: a stream of user data
  @override
  Stream<Either<Failure, MyUserModel?>> getUserStream(String userId) async* {
    try {
      final stream = datasource.getUserStream(userId);

      await for (final user in stream) {
        yield Right(user);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  /// updateUser is a method that updates the user data
  ///
  /// Parameters:
  /// - [user]: is the user data
  /// - [pfp]: is the profile picture file
  ///
  /// Returns:
  /// - `Future<Either<Failure, void>>`: a future of either failure or void
  @override
  Future<Either<Failure, void>> updateUser(MyUser user, File? pfp) async {
    try {
      await datasource.updateUser(
        MyUserModel.fromEntity(
          user,
        ),
        pfp,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
