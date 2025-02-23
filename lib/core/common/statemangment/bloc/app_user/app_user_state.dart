part of 'app_user_bloc.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}


final class AppUserLoading extends AppUserState {}


final class AppUserLoaded extends AppUserState {
  final MyUser user;

  AppUserLoaded(this.user);
}

final class AppUserError extends AppUserState {
  final String message;

  AppUserError(this.message);
}

// user doesnt exist
final class AppUserNotFound extends AppUserState {}

// user updated
final class AppUserUpdated extends AppUserState {}
