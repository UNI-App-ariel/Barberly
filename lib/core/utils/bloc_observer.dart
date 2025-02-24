import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A custom observer for tracking the lifecycle and events of BLoCs in the application.
///
/// This class extends [BlocObserver] and overrides its methods to log events, transitions, errors,
/// changes, closures, and creations of BLoCs for debugging and monitoring purposes.
class AppBlocObserver extends BlocObserver {
  /// Called when an event is added to a [Bloc].
  ///
  /// Logs the event and the corresponding [Bloc].
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('Event: $event in Bloc: $bloc');
  }

  /// Called when a transition occurs in a [Bloc].
  ///
  /// Logs the [Transition] and the corresponding [Bloc].
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('Transition: $transition in Bloc: $bloc');
  }

  /// Called when an error occurs in a [Bloc].
  ///
  /// Logs the [error] and the corresponding [Bloc], along with the [stackTrace].
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('Error: $error in Bloc: $bloc');
  }

  /// Called when a change occurs in a [Bloc].
  ///
  /// Logs the [Change] and the corresponding [Bloc].
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('Change: $change in Bloc: $bloc');
  }

  /// Called when a [Bloc] is closed.
  ///
  /// Logs the closure of the corresponding [Bloc].
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('Closed: $bloc');
  }

  /// Called when a [Bloc] is created.
  ///
  /// Logs the creation of the corresponding [Bloc].
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('Created: $bloc');
  }
}
