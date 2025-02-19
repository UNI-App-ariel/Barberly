part of 'owner_gallary_bloc.dart';

@immutable
sealed class OwnerGallaryState {}

final class OwnerGallaryInitial extends OwnerGallaryState {}

final class OwnerGallaryLoading extends OwnerGallaryState {}

final class OwnerGallaryError extends OwnerGallaryState {
  final String message;

  OwnerGallaryError(this.message);
}

final class OwnerGallaryLoaded extends OwnerGallaryState {
  final List<File> images;

  OwnerGallaryLoaded(this.images);
}


final class OwnerGallaryImagesPicked extends OwnerGallaryState {
  final List<File> images;

  OwnerGallaryImagesPicked(this.images);
}