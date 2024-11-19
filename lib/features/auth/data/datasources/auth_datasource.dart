import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_app/core/errors/exceptions.dart';

abstract interface class AuthDatasource {
  Future<void> loginWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password);
  Future<void> logout();
  Future<void> getCurrentUser();
}

class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _auth;

  AuthDatasourceImpl(this._auth);

  @override
  Future<void> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
