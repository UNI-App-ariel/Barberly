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

// register with email and password
class RegisterWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  RegisterWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}
