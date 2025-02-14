import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/usecases/availability/stream_availability.dart';
import 'package:uni_app/core/common/domian/usecases/availability/update_availability.dart';

part 'shop_availability_event.dart';
part 'shop_availability_state.dart';

class ShopAvailabilityBloc
    extends Bloc<ShopAvailabilityEvent, ShopAvailabilityState> {
  StreamSubscription? _streamSubscription;

  final StreamAvailabilityUseCase _streamAvailabilityUseCase;
  final UpdateAvailabilityUsecase _updateAvailabilityUsecase;

  ShopAvailabilityBloc({
    required StreamAvailabilityUseCase streamAvailabilityUseCase,
    required UpdateAvailabilityUsecase updateAvailabilityUsecase,
  })  : _streamAvailabilityUseCase = streamAvailabilityUseCase,
        _updateAvailabilityUsecase = updateAvailabilityUsecase,
        super(ShopAvailabilityInitial()) {
    on<ShopAvailabilityEvent>((event, emit) {});

    on<StreamAvailabilityEvent>(_onStreamAvailability);

    // update availability
    on<UpdateAvailabilityEvent>(_onUpdateAvailability);
  }

  FutureOr<void> _onStreamAvailability(StreamAvailabilityEvent event,
      Emitter<ShopAvailabilityState> emit) async {
    emit(ShopAvailabilityLoading());
    _streamSubscription?.cancel();

    _streamSubscription = _streamAvailabilityUseCase(event.shopId).listen(
      (availability) {
        availability.fold(
          (failure) {
            emit(ShopAvailabilityError(failure.message));
          },
          (availability) {
            final parsedAvailability = _parseAvailability(availability);
            emit(ShopAvailabilityLoaded(parsedAvailability));
          },
        );
      },
      onError: (error) {
        emit(ShopAvailabilityError(error.toString()));
      },
    );

    await _streamSubscription?.asFuture();
  }

  FutureOr<void> _onUpdateAvailability(UpdateAvailabilityEvent event,
      Emitter<ShopAvailabilityState> emit) async {
    emit(ShopAvailabilityLoading());
    final result = await _updateAvailabilityUsecase(event.availability);
    result.fold(
      (failure) {
        emit(ShopAvailabilityError(failure.message));
      },
      (availability) {
      },
    );
  }

  // Helper function to parse and filter availability data
  Availability _parseAvailability(Availability availability) {
    // Map to hold sorted and filtered availability data
    Map<DateTime, List<TimeSlot>> availabilityData = {};

    // Define the current date and time
    DateTime now = DateTime.now();

    // Sort dates and filter past dates in one step
    List<DateTime> sortedDates = availability.timeSlots.keys
        .where((date) => date.isAfter(now.subtract(const Duration(days: 1))))
        .toList()
      ..sort();

    // Filter time slots, remove past and booked slots, and sort them
    for (DateTime date in sortedDates) {
      List<TimeSlot> slots = availability.timeSlots[date]!.where(
        (slot) {
          final slotTime = DateTime(date.year, date.month, date.day,
              slot.startTime.hour, slot.startTime.minute);
          return slotTime.isAfter(now);
        },
      ).toList();

      // Only add to availabilityData if there are remaining slots
      // if (slots.isNotEmpty) {
      //   slots.sort((a, b) => a.startTime.compareTo(b.startTime));
      availabilityData[date] = slots;
      // }
    }

    return availability.copyWith(timeSlots: availabilityData);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
