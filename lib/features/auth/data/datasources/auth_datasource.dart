import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/features/auth/data/models/user_model.dart';

/// An interface for authentication data source operations.
abstract interface class AuthDatasource {
  Future<MyUserModel?> loginWithEmail(String email, String password);
  Future<MyUserModel?> signUpWithEmail(
      String name, String email, String password);
  Future<void> logout();
  Future<MyUserModel?> getCurrentUser();
  Future<MyUserModel?> signInWithGoogle();
  Future<MyUserModel?> signInWithFacebook();
}

/// Implementation of the AuthDatasource interface for Firebase authentication.
class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthDatasourceImpl({
    required this.auth,
    required this.firestore,
  });

  /// Retrieves the currently authenticated user from Firebase.
  ///
  /// If the user exists in Firestore, it returns the user as a [MyUserModel].
  /// If the user does not exist in Firestore, it returns a minimal [MyUserModel]
  /// with only the user ID and email.
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

  /// Logs in a user with their email and password.
  ///
  /// If successful, it retrieves the user document from Firestore and returns it
  /// as a [MyUserModel]. If the user does not exist in Firestore, it returns
  /// a minimal [MyUserModel] with the user ID and email.
  @override
  Future<MyUserModel?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

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

  /// Logs out the currently authenticated user from Firebase.
  ///
  /// This method does not return any data.
  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Signs up a new user with their name, email, and password.
  ///
  /// After successful registration, it saves the user details to Firestore
  /// and returns the newly created [MyUserModel].
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
        accountType: 'email',
      );

      await firestore.collection('users').doc(user.id).set(user.toMap());

      return user;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Signs in a user with their Google account.
  ///
  /// If successful, it retrieves the user document from Firestore and returns
  /// it as a [MyUserModel]. If the user does not exist, it saves the user
  /// details to Firestore and returns a new [MyUserModel].
  @override
  Future<MyUserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        await userDoc.reference.update({
          'name': userCredential.user!.displayName,
          'photoUrl': userCredential.user!.photoURL,
        });

        return MyUserModel.fromMap(userDoc.data()!);
      } else {
        await firestore.collection('users').doc(userCredential.user!.uid).set(
              MyUserModel(
                id: userCredential.user!.uid,
                email: userCredential.user!.email!,
                name: userCredential.user!.displayName!,
                photoUrl: userCredential.user!.photoURL,
                accountType: 'google',
              ).toMap(),
            );
        return MyUserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName!,
          photoUrl: userCredential.user!.photoURL,
          accountType: 'google',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Generates a random nonce string of a given length.
  ///
  /// The default length is 32 characters. This nonce can be used for security
  /// purposes during authentication processes.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Generates the SHA256 hash of the provided raw nonce.
  ///
  /// This hash can be used to enhance security during authentication processes.
  String hashNonce(String rawNonce) {
    final bytes = utf8.encode(rawNonce);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Signs in a user with their Facebook account.
  ///
  /// If successful, it retrieves the user document from Firestore and returns
  /// it as a [MyUserModel]. If the user does not exist, it saves the user
  /// details to Firestore and returns a new [MyUserModel].
  @override
  Future<MyUserModel?> signInWithFacebook() async {
    try {
      final rawNonce = generateNonce();
      final LoginResult result = await FacebookAuth.instance.login(
        loginTracking: LoginTracking.limited,
        nonce: hashNonce(rawNonce),
      );
      if (result.status == LoginStatus.success) {
        log('------> ${result.accessToken!.tokenString}-----');
        log('Facebook Login Status: ${result.status}');
        if (result.accessToken != null) {
          log('Access Token: ${result.accessToken!.tokenString}');
          log('Token Type: ${result.accessToken!.type}');
        }
        final OAuthCredential credential;
        if (Platform.isIOS) {
          credential = OAuthProvider('facebook.com').credential(
            idToken: result.accessToken!.tokenString,
            rawNonce: rawNonce,
          );
        } else {
          credential =
              FacebookAuthProvider.credential(result.accessToken!.tokenString);
        }

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        final userDoc = await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          await userDoc.reference.update({
            'name': userCredential.user!.displayName,
            'photoUrl': userCredential.user!.photoURL,
          });
          return MyUserModel.fromMap(userDoc.data()!);
        } else {
          await firestore.collection('users').doc(userCredential.user!.uid).set(
                MyUserModel(
                  id: userCredential.user!.uid,
                  email: userCredential.user!.email!,
                  name: userCredential.user!.displayName!,
                  photoUrl: userCredential.user!.photoURL,
                  accountType: 'facebook',
                ).toMap(),
              );
          return MyUserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName!,
            photoUrl: userCredential.user!.photoURL,
            accountType: 'facebook',
          );
        }
      } else {
        return null;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
