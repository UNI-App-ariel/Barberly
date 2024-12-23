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
  Stream<Either<Failure, MyUserModel?>> getUserStream(String userId) {
    try {
      return datasource.getUserStream(userId).map((event) => right(event));
    } on ServerException catch (e) {
      return Stream.value(left(Failure(e.message)));
    } catch (e) {
      return Stream.value(left(Failure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(MyUser user) async {
    try {

      await datasource.updateUser(MyUserModel.fromEntity(user));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
