import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uni_app/core/errors/exceptions.dart';

import 'package:uni_app/features/auth/data/models/user_model.dart';

/// This class is responsible for fetching and updating user data from Firestore.
/// It uses `Firebase Firestore` and `Firebase Storage`.
abstract interface class AppUserDatasource {
  /// Method to get a stream of user data from Firestore.
  ///
  /// Parameters:
  /// - [userId]: the `id` of the user whose data is to be fetched
  ///
  /// Returns:
  /// - a stream of [MyUserModel]
  Stream<MyUserModel?> getUserStream(String userId);

  /// Method to update user data in Firestore.
  ///
  /// Parameters:
  /// - [user]: the user data to be updated
  /// - [pfp]: the new profile picture of the user

  Future<void> updateUser(MyUserModel user, File? pfp);
}

/// This class is responsible for fetching and updating user data from Firestore.
/// It uses `Firebase Firestore` and `Firebase Storage`.
///
/// Parameters:
/// - [firestore]: an instance of FirebaseFirestore
/// - [storage]: an instance of FirebaseStorage
class AppUserDatasourceImpl implements AppUserDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AppUserDatasourceImpl({required this.firestore, required this.storage});

  /// Method to get a stream of user data from Firestore.
  ///
  /// Parameters:
  /// - [userId]: the `id` of the user whose data is to be fetched
  ///
  /// Returns:
  /// - a stream of [MyUserModel]
  /// 
  /// Throws:
  /// - [ServerException]: if an error occurs while fetching the user data
  @override
  Stream<MyUserModel?> getUserStream(String userId) {
    try {
      final stream = firestore.collection('users').doc(userId).snapshots();

      return stream.map((event) {
        if (event.exists) {
          return MyUserModel.fromMap(event.data()!);
        } else {
          return null;
        }
      });
    } on FirebaseException catch (e) {
      throw ServerException('${e.message} - getUserStream');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Method to update user data in Firestore.
  /// 
  /// Parameters:
  /// - [user]: the user data to be updated
  /// - [pfp]: the new profile picture of the user
  ///
  /// Returns:
  /// - a [Future<void>]
  /// 
  /// Throws:
  /// - [ServerException]: if an error occurs while updating the user data
  @override
  Future<void> updateUser(MyUserModel user, File? pfp) async {
    try {
      // if pfp is not null, upload it to storage
      if (pfp != null) {
        final ref = storage.ref().child('pfp/${user.id}/pfp.jpg');
        await ref.putFile(pfp);
        final url = await ref.getDownloadURL();

        user = user.copyWith(photoUrl: url);
      }

      return await firestore
          .collection('users')
          .doc(user.id)
          .update(user.toMap());
    } on FirebaseException catch (e) {
      throw ServerException('${e.message} - updateUser');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
