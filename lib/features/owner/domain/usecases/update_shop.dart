import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';

class UpdateOwnerShopUseCase implements UseCase<void, UpdateOwnerShopParams> {
  final OwnerShopRepo repository;

  UpdateOwnerShopUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateOwnerShopParams params) async {
    return await repository.updateOwnerShop(
        params.shop, params.pickedImage, params.galleryImages);
  }
}

// new class update params that takes barbershop and list of images
class UpdateOwnerShopParams {
  final Barbershop shop;
  final File? pickedImage;
  final List<File>? galleryImages;

  UpdateOwnerShopParams(this.shop, this.pickedImage, this.galleryImages);
}

class DeleteImageFromGalleryUseCase
    implements UseCase<void, DeleteImageFromGalleryParams> {
  final OwnerShopRepo repository;

  DeleteImageFromGalleryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
      DeleteImageFromGalleryParams params) async {
    return await repository.deleteImageFromGallery(
        params.shopId, params.imageUrl);
  }
}

class DeleteImageFromGalleryParams {
  final String imageUrl;
  final String shopId;

  DeleteImageFromGalleryParams(this.shopId, this.imageUrl);
}
