part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// user is authenticated
final class Authenticated extends AuthState {
  final MyUser user;

  Authenticated(this.user);
}

// user is not authenticated
final class Unauthenticated extends AuthState {}

// loading
final class AuthLoading extends AuthState {}

// error
final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

