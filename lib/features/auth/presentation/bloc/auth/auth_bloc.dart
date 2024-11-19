import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/features/auth/domain/usecases/singin_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // usecase
  final SinginWithEmailUsecase _singinWithEmailUsecase;
  AuthBloc({
    required SinginWithEmailUsecase singinWithEmailUsecase,
  })  : _singinWithEmailUsecase = singinWithEmailUsecase,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});

    // sign in with email and password
    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);
  }

  Future<void> _onSignInWithEmailAndPassword(
      SignInWithEmailAndPassword event, Emitter<AuthState> emit) async {
    final result = await _singinWithEmailUsecase(
      SinginWithEmailParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (_) {
        emit(Authenticated());
      },
    );
  }
}
