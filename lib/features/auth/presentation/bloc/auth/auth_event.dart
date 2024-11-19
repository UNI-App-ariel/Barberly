part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

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
  final String email;
  final String password;

  SignUpWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}
