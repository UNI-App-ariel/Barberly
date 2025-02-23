import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class OwnerShopRepo {
  Stream<Either<Failure, Barbershop>> getOwnerShop(String shopId);
  Future<Either<Failure, void>> updateOwnerShop(
      Barbershop ownerShop, File? pickedImage, List<File>? galleryImages);
  Future<Either<Failure, void>> deleteOwnerShop(String id);
  Future<Either<Failure, void>> deleteImageFromGallery(
      String shopId, String imageUrl);
}
