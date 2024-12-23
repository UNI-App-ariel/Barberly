import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_app/core/errors/exceptions.dart';

import 'package:uni_app/features/auth/data/models/user_model.dart';

abstract interface class AppUserDatasource {
  Stream<MyUserModel?> getUserStream(String userId);
  Future<void> updateUser(MyUserModel user);
}

class AppUserDatasourceImpl implements AppUserDatasource {
  final FirebaseFirestore firestore;

  AppUserDatasourceImpl({required this.firestore});

  @override
  Stream<MyUserModel?> getUserStream(String userId) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .snapshots()
          .asyncMap((event) async {
        final data = event.data();
        if (data != null) {
          return MyUserModel.fromMap(data);
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

  @override
  Future<void> updateUser(MyUserModel user) {
    try {
      return firestore.collection('users').doc(user.id).update(user.toMap());
    } on FirebaseException catch (e) {
      throw ServerException('${e.message} - updateUser');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
