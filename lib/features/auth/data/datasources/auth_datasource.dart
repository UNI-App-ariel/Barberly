import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/features/auth/data/models/user_model.dart';

abstract interface class AuthDatasource {
  Future<MyUserModel?> loginWithEmail(String email, String password);
  Future<MyUserModel?> signUpWithEmail(
      String name, String email, String password);
  Future<void> logout();
  Future<MyUserModel?> getCurrentUser();
  Future<MyUserModel?> signInWithGoogle();
  Future<MyUserModel?> signInWithFacebook();
}

class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthDatasourceImpl({
    required this.auth,
    required this.firestore,
  });

  @override
  Future<MyUserModel?> getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return MyUserModel.fromMap(userDoc.data()!);
        } else {
          return MyUserModel(
            id: user.uid,
            email: user.email!,
            name: '',
          );
        }
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MyUserModel?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // get user from firestore
      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (userDoc.exists) {
        return MyUserModel.fromMap(userDoc.data()!);
      } else {
        return MyUserModel(
          id: userCredential.user!.uid,
          email: email,
          name: '',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MyUserModel?> signUpWithEmail(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = MyUserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // save user to firestore
      await firestore.collection('users').doc(user.id).set(user.toMap());

      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MyUserModel?> signInWithGoogle() async {
    try {
      // begin sign in with google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // check if user cancelled the sign in
      if (gUser == null) {
        return null;
      }

      // obtain the auth details from the request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // sign in to firebase
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // get user from firestore
      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        return MyUserModel.fromMap(userDoc.data()!);
      } else {
        // save user to firestore
        await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(MyUserModel(
              id: userCredential.user!.uid,
              email: userCredential.user!.email!,
              name: userCredential.user!.displayName!,
            ).toMap());
        return MyUserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName!,
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<MyUserModel?> signInWithFacebook() {
    

    
  }
}
