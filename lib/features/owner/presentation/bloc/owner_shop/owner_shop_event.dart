part of 'owner_shop_bloc.dart';

@immutable
sealed class OwnerShopEvent {}

class GetShopEvent extends OwnerShopEvent {
  final String ownerId;

  GetShopEvent(this.ownerId);
}

class UpdateShopEvent extends OwnerShopEvent {
  final Barbershop shop;
  final File? pickedImage;
  final List<File>? galleryImages;

  UpdateShopEvent(this.shop, {this.pickedImage, this.galleryImages});
}

class DeleteShopEvent extends OwnerShopEvent {
  final String shopId;

  DeleteShopEvent(this.shopId);
}

// pick shop image
class PickShopImageEvent extends OwnerShopEvent {
  final bool isCamera; // If true, take a picture. If false, pick from gallery.

  PickShopImageEvent({this.isCamera = false});
}
