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

class AppUserBloc extends Bloc<AppUserEvent, AppUserState> {
  MyUser? _currentUser;

  MyUser? get currentUser => _currentUser;

  // usecase
  final StreamAppUserUseCase streamAppUserUseCase;
  final UpdateAppUserUseCase updateAppUserUseCase;

  StreamSubscription? _userStreamSubscription;

  AppUserBloc({
    required this.streamAppUserUseCase,
    required this.updateAppUserUseCase,
  }) : super(AppUserInitial()) {
    on<AppUserEvent>((event, emit) {});

    // stream user
    on<StreamUserEvent>(_onStreamUserEvent);

    // update user
    on<UpdateUserEvent>(_onUpdateUserEvent);

    // logout
    on<LogoutEvent>((event, emit) {
      _userStreamSubscription?.cancel();
      _currentUser = null;
      emit(AppUserInitial());
    });
  }

  void _onStreamUserEvent(
      StreamUserEvent event, Emitter<AppUserState> emit) async {
    _userStreamSubscription?.cancel();
    _userStreamSubscription = streamAppUserUseCase(event.userId).listen(
      (user) {
        user.fold((failure) => emit(AppUserError(failure.message)), (user) {
          if (user == null) {
            emit(AppUserNotFound());
          } else {
            _currentUser = user;
            OneSignalService().login(user.id);
            emit(AppUserLoaded(user));
          }
        });
      },
      onError: (e) {
        emit(AppUserError(e.toString()));
      },
    );

    await _userStreamSubscription?.asFuture();
  }

  void _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<AppUserState> emit) async {
    emit(AppUserLoading());
    final result = await updateAppUserUseCase(
        UpdateAppUserParams(user: event.user, pfp: event.pfp));
    result.fold(
      (failure) => emit(AppUserError(failure.message)),
      (_) {
        emit(AppUserUpdated());
        add(StreamUserEvent(event.user.id));
      },
    );
  }
}
