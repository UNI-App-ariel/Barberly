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
  Future<Either<Failure, Barbershop>> getOwnerShop(String shopId) async {
    try {
      final data = await datasource.getOwnerShop(shopId);
      return Right(data);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOwnerShop(
      Barbershop ownerShop) async {
    try {
      final BarbershopModel ownerShopModel = BarbershopModel.fromEntity(ownerShop);
      await datasource.updateOwnerShop(ownerShopModel);
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
}
