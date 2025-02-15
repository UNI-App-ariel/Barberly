import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uni_app/core/errors/exceptions.dart';

import 'package:uni_app/features/auth/data/models/user_model.dart';

abstract interface class AppUserDatasource {
  Stream<MyUserModel?> getUserStream(String userId);
  Future<void> updateUser(MyUserModel user, File? pfp);
}

class AppUserDatasourceImpl implements AppUserDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AppUserDatasourceImpl({required this.firestore, required this.storage});

  @override
  Stream<MyUserModel?> getUserStream(String userId) async* {
    try {
      final stream = firestore.collection('users').doc(userId).snapshots();

      await for (final snap in stream) {
        if (snap.exists) {
          yield MyUserModel.fromMap(snap.data()!);
        } else {
          yield null;
        }
      }
    } on FirebaseException catch (e) {
      throw ServerException('${e.message} - getUserStream');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

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
