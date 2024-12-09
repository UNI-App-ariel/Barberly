import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/usecases/stream_availability.dart';

part 'shop_availability_event.dart';
part 'shop_availability_state.dart';

class ShopAvailabilityBloc
    extends Bloc<ShopAvailabilityEvent, ShopAvailabilityState> {
  StreamSubscription? _streamSubscription;

  final StreamAvailabilityUseCase _streamAvailabilityUseCase;

  ShopAvailabilityBloc(
      {required StreamAvailabilityUseCase streamAvailabilityUseCase})
      : _streamAvailabilityUseCase = streamAvailabilityUseCase,
        super(ShopAvailabilityInitial()) {
    on<ShopAvailabilityEvent>((event, emit) {});

    on<StreamAvailabilityEvent>(_onStreamAvailability);
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
