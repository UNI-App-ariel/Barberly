import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';

import 'package:uni_app/features/auth/domain/entities/user.dart';


/// AppUserRepo is an abstract class that defines the methods that should be implemented by AppUserRepoImpl
abstract interface class AppUserRepo {
  /// getUserStream is a method that returns a stream of user data
  ///
  /// Parameters:
  /// - [userId]: is the user id
  ///
  /// Returns:
  /// - `Stream<Either<Failure, MyUserModel?>>`: a stream of user data
  Stream<Either<Failure, MyUser?>> getUserStream(String userId);

  /// updateUser is a method that updates the user data
  ///
  /// Parameters:
  /// - [user]: is the user data
  /// - [pfp]: is the profile picture file
  ///
  /// Returns:
  /// - `Future<Either<Failure, void>>`: a future of either failure or void
  Future<Either<Failure, void>> updateUser(MyUser user, File? pfp);
}
