part of 'owner_shop_bloc.dart';

@immutable
sealed class OwnerShopEvent {}

class GetShopEvent extends OwnerShopEvent {
  final String ownerId;

  GetShopEvent(this.ownerId);
}

class UpdateShopEvent extends OwnerShopEvent {
  final Barbershop shop;

  UpdateShopEvent(this.shop);
}

class DeleteShopEvent extends OwnerShopEvent {
  final String shopId;

  DeleteShopEvent(this.shopId);
}

// pick shop image
class PickShopImageEvent extends OwnerShopEvent {
}


