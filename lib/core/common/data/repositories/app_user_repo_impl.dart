import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/datasources/app_user_datasource.dart';
import 'package:uni_app/core/common/domian/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/auth/data/models/user_model.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

class AppUserRepoImpl implements AppUserRepo {
  final AppUserDatasource datasource;

  AppUserRepoImpl({required this.datasource});

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

  @override
  Future<Either<Failure, void>> updateUser(MyUser user, File? pfp) async {
    try {

      await datasource.updateUser(MyUserModel.fromEntity(user,), pfp);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
