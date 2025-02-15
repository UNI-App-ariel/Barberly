part of 'app_user_bloc.dart';

@immutable
sealed class AppUserEvent {}

// stream user
class StreamUserEvent extends AppUserEvent {
  final String userId;

  StreamUserEvent(this.userId);
}

// update user
class UpdateUserEvent extends AppUserEvent {
  final MyUser user;
  final File? pfp;

  UpdateUserEvent({required this.user, this.pfp});
}

// logout
class LogoutEvent extends AppUserEvent {}