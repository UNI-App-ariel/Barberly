part of 'owner_gallary_bloc.dart';

@immutable
sealed class OwnerGallaryEvent {}

class PickGallaryEvent extends OwnerGallaryEvent {
  final bool isCamera;

  PickGallaryEvent({required this.isCamera});
}

class ResetGalleryEvent extends OwnerGallaryEvent {}

class DeleteImageFromGalleryEvent extends OwnerGallaryEvent {
  final String shopId;
  final String imageUrl;

  DeleteImageFromGalleryEvent({required this.shopId, required this.imageUrl});
}
