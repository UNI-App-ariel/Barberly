import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/usecases/get_owner_appointments_streams.dart';

part 'owner_appointments_event.dart';
part 'owner_appointments_state.dart';

class OwnerAppointmentsBloc
    extends Bloc<OwnerAppointmentsEvent, OwnerAppointmentsState> {
  final GetOwnerAppointmentsStreamsUseCase getOwnerAppointmentsUseCase;
  StreamSubscription? _streamSubscription;

  OwnerAppointmentsBloc({
    required this.getOwnerAppointmentsUseCase,
  }) : super(OwnerAppointmentsInitial()) {
    on<OwnerAppointmentsEvent>((event, emit) {});

    on<GetOwnerAppointemntsEvent>((event, emit) async {
      _streamSubscription?.cancel();
      _streamSubscription = getOwnerAppointmentsUseCase(event.shopId).listen(
        (failureOrAppointments) {
          failureOrAppointments.fold(
            (failure) => emit(OwnerAppointmentsError(failure.message)),
            (appointments) => emit(OwnerAppointmentsLoaded(appointments)),
          );
        },
      );
      await _streamSubscription?.asFuture();
    });
  }
}
