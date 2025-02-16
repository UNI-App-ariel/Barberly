import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/statemangment/bloc/app_user/app_user_bloc.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/core/utils/notifications.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';
import 'package:uni_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:uni_app/features/auth/domain/usecases/logout.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_email.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_facbook.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:uni_app/features/auth/domain/usecases/signup_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // bloc
  final AppUserBloc appUserBloc;

  // usecase
  final GetCurrentUserUseCase _getCurrentUserUsecase;
  final SignUpWithEmailUseCase _signupWithEmailUsecase;
  final SignInWithEmailUseCase _signinWithEmailUsecase;
  final LogOutUseCase _logOutUseCase;
  final SigninWithGoogleUseCase _signinWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;

  // fields
  MyUser? _currentUser;

  // getters
  MyUser? get currentUser => _currentUser;

  AuthBloc({
    required GetCurrentUserUseCase getCurrentUserUsecase,
    required SignInWithEmailUseCase singinWithEmailUsecase,
    required SignUpWithEmailUseCase signupWithEmailUsecase,
    required LogOutUseCase logOutUseCase,
    required SigninWithGoogleUseCase signinWithGoogleUseCase,
    required SignInWithFacebookUseCase signInWithFacebookUseCase,
    required this.appUserBloc,
  })  : _getCurrentUserUsecase = getCurrentUserUsecase,
        _signinWithEmailUsecase = singinWithEmailUsecase,
        _signupWithEmailUsecase = signupWithEmailUsecase,
        _signinWithGoogleUseCase = signinWithGoogleUseCase,
        _signInWithFacebookUseCase = signInWithFacebookUseCase,
        _logOutUseCase = logOutUseCase,
        super(AuthInitial()) {
    // listen to auth events
    on<AuthEvent>((event, emit) {});

    // check if user is authenticated
    on<CheckAuth>(_onCheckAuth);

    // sign in with email and password
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);

    // sign up with email and password
    on<SignUpWithEmailAndPassword>(_onSignUpWithEmailAndPassword);

    // log out
    on<AuthLogOut>(_onLogOut);

    // sign in with google
    on<SignInWithGoogle>(_onSignInWithGoogle);

    // sign in with facebook
    on<SignInWithFacebook>(_onSignInWithFacebook);
  }

  Future<void> _onCheckAuth(CheckAuth event, Emitter<AuthState> emit) async {
    final result = await _getCurrentUserUsecase(NoParams());

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (user) {
        _currentUser = user;
        if (user != null) {
          emit(Authenticated(user));
          appUserBloc.add(StreamUserEvent(user.id));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInWithEmailAndPassword(
      SignInWithEmailAndPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signinWithEmailUsecase(
      SinginWithEmailParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (user) {
        _currentUser = user;
        if (user != null) {
          emit(Authenticated(user));
          appUserBloc.add(StreamUserEvent(user.id));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignUpWithEmailAndPassword(
      SignUpWithEmailAndPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signupWithEmailUsecase(
      SignupWithEmailParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (user) {
        _currentUser = user;
        if (user != null) {
          emit(Authenticated(user));
          appUserBloc.add(StreamUserEvent(user.id));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onLogOut(AuthLogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _logOutUseCase(NoParams());

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (_) {
        _currentUser = null;
        emit(Unauthenticated());
        appUserBloc.add(LogoutEvent());
        OneSignalService().logout();
      },
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    final result = await _signinWithGoogleUseCase(NoParams());
    emit(AuthLoading());

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (user) {
        _currentUser = user;
        if (user != null) {
          emit(Authenticated(user));
          appUserBloc.add(StreamUserEvent(user.id));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInWithFacebook(
      SignInWithFacebook event, Emitter<AuthState> emit) async {
    final result = await _signInWithFacebookUseCase(NoParams());
    emit(AuthLoading());

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (user) {
        _currentUser = user;
        if (user != null) {
          emit(Authenticated(user));
          appUserBloc.add(StreamUserEvent(user.id));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}
