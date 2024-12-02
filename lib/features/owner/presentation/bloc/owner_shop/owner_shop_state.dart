part of 'owner_shop_bloc.dart';

@immutable
sealed class OwnerShopState {}

final class OwnerShopInitial extends OwnerShopState {}

final class OwnerShopLoading extends OwnerShopState {}

final class OwnerShopLoaded extends OwnerShopState {
  final Barbershop shop;

  OwnerShopLoaded(this.shop);
}

final class OwnerShopError extends OwnerShopState {
  final String message;

  OwnerShopError(this.message);
}