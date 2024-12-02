

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';

part 'shop_availability_event.dart';
part 'shop_availability_state.dart';

class ShopAvailabilityBloc extends Bloc<ShopAvailabilityEvent, ShopAvailabilityState> {
  ShopAvailabilityBloc() : super(ShopAvailabilityInitial()) {
    on<ShopAvailabilityEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
