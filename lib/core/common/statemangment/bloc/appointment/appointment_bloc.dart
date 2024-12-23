import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/book_appointment.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/cancel_appointment.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  CancelAppointmentUseCase cancelAppointmentUseCase;
  BookAppointmentUseCase bookAppointmentUseCase;

  AppointmentBloc({
    required this.cancelAppointmentUseCase,
    required this.bookAppointmentUseCase,
  }) : super(AppointmentInitial()) {
    on<AppointmentEvent>((event, emit) {

    });

    on<BookAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      final result = await bookAppointmentUseCase(event.appointment);
      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentBooked(event.appointment)),
      );
    });

    on<CancelAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      final result = await cancelAppointmentUseCase(event.appointment.id);
      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentInitial()),
      );
    });
  }
}
