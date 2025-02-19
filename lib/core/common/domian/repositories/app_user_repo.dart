import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';

import 'package:uni_app/features/auth/domain/entities/user.dart';

abstract interface class AppUserRepo {
  Stream<Either<Failure, MyUser?>> getUserStream(String userId);
  Future<Either<Failure, void>> updateUser(MyUser user, File? pfp);
}