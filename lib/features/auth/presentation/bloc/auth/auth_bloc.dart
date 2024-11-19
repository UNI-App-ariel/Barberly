import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/features/auth/domain/usecases/signin_with_email.dart';
import 'package:uni_app/features/auth/domain/usecases/signup_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // usecase
  final SignupWithEmail _signupWithEmailUsecase;
  final SignInWithEmailUseCase _signinWithEmailUsecase;

  AuthBloc({
    required SignInWithEmailUseCase singinWithEmailUsecase,
    required SignupWithEmail signupWithEmailUsecase,
  })  : _signinWithEmailUsecase = singinWithEmailUsecase, 
        _signupWithEmailUsecase = signupWithEmailUsecase,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});

    on<SignInWithEmailAndPassword>(_onSignInWithEmailAndPassword);  // sign in with email and password    
    on<SignUpWithEmailAndPassword>(_onSignUpWithEmailAndPassword);  // sign up with email and password
  }

  Future<void> _onSignInWithEmailAndPassword(
      SignInWithEmailAndPassword event, Emitter<AuthState> emit) async {
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
      (_) {
        emit(Authenticated());
      },
    );
  }

  Future<void> _onSignUpWithEmailAndPassword(
      SignUpWithEmailAndPassword event, Emitter<AuthState> emit) async {
    final result = await _signupWithEmailUsecase(
      SignupWithEmailParams(
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
