import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/owner/data/datasources/owner_shop_datasource.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';

class OwnerShopRepoImpl implements OwnerShopRepo {
  final OwnerShopDatasource datasource;

  OwnerShopRepoImpl({required this.datasource});

  @override
  Stream<Either<Failure, Barbershop>> getOwnerShop(String shopId) async* {
    try {
      final data =  datasource.getOwnerShop(shopId);
      await for (final snapshot in data) {
        yield Right(snapshot);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    } catch (e) {
      yield Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOwnerShop(Barbershop ownerShop,
      File? pickedImage, List<File>? galleryImages) async {
    try {
      final BarbershopModel ownerShopModel =
          BarbershopModel.fromEntity(ownerShop);
      await datasource.updateOwnerShop(
          ownerShopModel, pickedImage, galleryImages);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOwnerShop(String id) async {
    try {
      await datasource.deleteOwnerShop(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImageFromGallery(
      String shopId, String imageUrl) async {
    try {
      await datasource.deleteImageFromGallery(shopId, imageUrl);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
