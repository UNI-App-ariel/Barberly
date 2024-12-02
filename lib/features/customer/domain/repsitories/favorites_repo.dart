import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class FavoritesRepo {
  Future<Either<Failure, List<Barbershop>>> getFavoriteShops(String userId);
}
