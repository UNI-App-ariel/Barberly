part of 'pfp_bloc.dart';

@immutable
sealed class PfpEvent {}

// pick image from gallery
class PickImageFromGallery extends PfpEvent {}

// pick image from camera
class PickImageFromCamera extends PfpEvent {}
