import 'package:fpdart/fpdart.dart';

import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class OwnerShopRepo {
  Future<Either<Failure, Barbershop>> getOwnerShop(String shopId);
  Future<Either<Failure, void>> updateOwnerShop(Barbershop ownerShop);
  Future<Either<Failure, void>> deleteOwnerShop(String id);
}