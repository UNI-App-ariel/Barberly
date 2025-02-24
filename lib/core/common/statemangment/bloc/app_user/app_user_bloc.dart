import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domain/usecases/app_user/stream_app_user.dart';
import 'package:uni_app/core/common/domain/usecases/app_user/update_app_user.dart';
import 'package:uni_app/core/utils/notifications.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

part 'app_user_event.dart';
part 'app_user_state.dart';

/// BLoC for managing application user state.
class AppUserBloc extends Bloc<AppUserEvent, AppUserState> {
  MyUser? _currentUser;

  MyUser? get currentUser => _currentUser;

  // Use cases for streaming and updating user data
  final StreamAppUserUseCase streamAppUserUseCase;
  final UpdateAppUserUseCase updateAppUserUseCase;

  StreamSubscription? _userStreamSubscription;

  AppUserBloc({
    required this.streamAppUserUseCase,
    required this.updateAppUserUseCase,
  }) : super(AppUserInitial()) {
    // Handling different events
    on<AppUserEvent>((event, emit) {});

    // Stream user event
    on<StreamUserEvent>(_onStreamUserEvent);

    // Update user event
    on<UpdateUserEvent>(_onUpdateUserEvent);

    // Logout event
    on<LogoutEvent>((event, emit) {
      _userStreamSubscription?.cancel();
      _currentUser = null;
      emit(AppUserInitial());
    });
  }

  /// Streams the user based on the provided user ID.
  void _onStreamUserEvent(
      StreamUserEvent event, Emitter<AppUserState> emit) async {
    _userStreamSubscription?.cancel(); // Cancel any existing subscription
    _userStreamSubscription = streamAppUserUseCase(event.userId).listen(
      (user) {
        user.fold(
          (failure) => emit(AppUserError(failure.message)),
          (user) {
            if (user == null) {
              emit(AppUserNotFound());
            } else {
              _currentUser = user;
              OneSignalService().login(user.id);
              emit(AppUserLoaded(user));
            }
          },
        );
      },
      onError: (e) {
        // Log the error for debugging
        debugPrint('User stream error: $e');
        emit(AppUserError(e.toString()));
      },
    );

    await _userStreamSubscription
        ?.asFuture(); // Wait for the subscription to complete
  }

  /// Updates the user information.
  void _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<AppUserState> emit) async {
    emit(AppUserLoading());
    final result = await updateAppUserUseCase(
        UpdateAppUserParams(user: event.user, pfp: event.pfp));
    result.fold(
      (failure) => emit(AppUserError(failure.message)),
      (_) {
        emit(AppUserUpdated());
        add(StreamUserEvent(event.user.id)); // Stream updated user
      },
    );
  }

  /// Clean up resources when the BLoC is closed.
  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();
    return super.close();
  }
}
