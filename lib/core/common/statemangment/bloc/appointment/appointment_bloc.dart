import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/usecases/appointment/book_appointment.dart';
import 'package:uni_app/core/common/domain/usecases/appointment/cancel_appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

/// Bloc responsible for managing appointment-related events and states.
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final CancelAppointmentUseCase cancelAppointmentUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;

  /// Creates an instance of [AppointmentBloc].
  ///
  /// Requires [cancelAppointmentUseCase] and [bookAppointmentUseCase]
  /// to perform operations related to canceling and booking appointments.
  AppointmentBloc({
    required this.cancelAppointmentUseCase,
    required this.bookAppointmentUseCase,
  }) : super(AppointmentInitial()) {
    // Handle booking appointment event
    on<BookAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      final result = await bookAppointmentUseCase(event.appointment);
      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentBooked(event.appointment)),
      );
    });

    // Handle canceling appointment event
    on<CancelAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      final result = await cancelAppointmentUseCase(event.appointment.id);
      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentInitial()), // or emit a success state
      );
    });
  }
}
