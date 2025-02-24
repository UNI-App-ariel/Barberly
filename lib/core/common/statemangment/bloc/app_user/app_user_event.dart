part of 'app_user_bloc.dart';

/// Base class for user-related events.
@immutable
sealed class AppUserEvent {}

/// Event to stream the user based on their user ID.
class StreamUserEvent extends AppUserEvent {
  final String userId;

  /// Constructor for the StreamUserEvent.
  ///
  /// [userId] is the ID of the user to be streamed.
  StreamUserEvent(this.userId);
}

/// Event to update the user information.
class UpdateUserEvent extends AppUserEvent {
  final MyUser user;
  final File? pfp;

  /// Constructor for the UpdateUserEvent.
  ///
  /// [user] is the user object containing updated information.
  /// [pfp] is the optional profile picture file to be updated.
  UpdateUserEvent({required this.user, this.pfp});
}

/// Event to log out the current user.
class LogoutEvent extends AppUserEvent {}
