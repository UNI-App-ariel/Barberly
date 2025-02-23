part of 'shop_availability_bloc.dart';

@immutable
sealed class ShopAvailabilityEvent {}

class StreamAvailabilityEvent extends ShopAvailabilityEvent {
  final String shopId;

  StreamAvailabilityEvent(this.shopId);
}

class UpdateAvailabilityEvent extends ShopAvailabilityEvent {
  final Availability availability;

  UpdateAvailabilityEvent(this.availability);
}
