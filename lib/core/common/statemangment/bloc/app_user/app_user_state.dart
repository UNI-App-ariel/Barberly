part of 'app_user_bloc.dart';

/// Base class for user-related states.
@immutable
sealed class AppUserState {}

/// Initial state when the user is not yet loaded.
final class AppUserInitial extends AppUserState {}

/// Loading state when user data is being fetched.
final class AppUserLoading extends AppUserState {}

/// State when user data is successfully loaded.
final class AppUserLoaded extends AppUserState {
  final MyUser user;

  /// Constructor for the AppUserLoaded state.
  ///
  /// [user] is the loaded user object.
  AppUserLoaded(this.user);
}

/// State representing an error during user operations.
final class AppUserError extends AppUserState {
  final String message;

  /// Constructor for the AppUserError state.
  ///
  /// [message] is the error message to be displayed.
  AppUserError(this.message);
}

/// State indicating that the user was not found.
final class AppUserNotFound extends AppUserState {}

/// State indicating that the user has been successfully updated.
final class AppUserUpdated extends AppUserState {}
