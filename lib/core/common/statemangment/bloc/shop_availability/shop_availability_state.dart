part of 'shop_availability_bloc.dart';

@immutable
sealed class ShopAvailabilityState {}

final class ShopAvailabilityInitial extends ShopAvailabilityState {}


final class ShopAvailabilityLoading extends ShopAvailabilityState {}

final class ShopAvailabilityLoaded extends ShopAvailabilityState {
  final Availability availability;

  ShopAvailabilityLoaded(this.availability);
}

final class ShopAvailabilityError extends ShopAvailabilityState {
  final String message;

  ShopAvailabilityError(this.message);
}
