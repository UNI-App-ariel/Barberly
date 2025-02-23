import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/common/domian/usecases/appointment/get_appointments.dart';

part 'booked_appointments_event.dart';
part 'booked_appointments_state.dart';

class BookedAppointmentsBloc
    extends Bloc<BookedAppointmentsEvent, BookedAppointmentsState> {
  // usecases
  GetAppointmentsUseCase getAppointmentsUseCase;

  // stream
  StreamSubscription? _bookedAppointmentsStream;

  BookedAppointmentsBloc({
    required this.getAppointmentsUseCase,
  }) : super(BookedAppointmentsInitial()) {
    on<BookedAppointmentsEvent>((event, emit) {});

    // stream booked appointments
    on<GetBookedAppointments>(_onGetBookedAppointments);
  }

  FutureOr<void> _onGetBookedAppointments(GetBookedAppointments event,
      Emitter<BookedAppointmentsState> emit) async {
    _bookedAppointmentsStream?.cancel();
    _bookedAppointmentsStream =
        getAppointmentsUseCase(event.userId).listen((res) {
      res.fold(
        (error) {
          emit(BookedAppointmentsError(error.message));
        },
        (appointments) {
          final sortedAppointments = _sortAndFilterAppointments(appointments);
          emit(BookedAppointmentsLoaded(sortedAppointments));
        },
      );
    }, onError: (error) {
      emit(BookedAppointmentsError(error.toString()));
    });

    await _bookedAppointmentsStream?.asFuture();
  }

  List<Appointment> _sortAndFilterAppointments(List<Appointment> appointments) {
    // sort appointments by date
    appointments.sort((a, b) => a.date.compareTo(b.date));

    // filter out appointments that are in the past
    appointments
        .removeWhere((element) => element.date.isBefore(DateTime.now()));

    return appointments;
  }
}
