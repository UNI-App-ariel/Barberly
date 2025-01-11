part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

// check if user is authenticated
class CheckAuth extends AuthEvent {}

// sign in with email and password
class SignInWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}

// sign up with email and password
class SignUpWithEmailAndPassword extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpWithEmailAndPassword({
    required this.name,
    required this.email,
    required this.password,
  });
}

// log out
class AuthLogOut extends AuthEvent {}

// sign in with google
class SignInWithGoogle extends AuthEvent {}

// sign in with facebook
class SignInWithFacebook extends AuthEvent {}
