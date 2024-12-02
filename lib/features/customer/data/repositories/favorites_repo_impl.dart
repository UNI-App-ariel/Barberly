import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/features/customer/data/datasources/favorites_datasource.dart';
import 'package:uni_app/features/customer/domain/repsitories/favorites_repo.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final FavoritesDataSource dataSource;

  FavoritesRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Barbershop>>> getFavoriteShops(
      String userId) async {
    try {
      final favoriteShops = await dataSource.getFavoriteShops(userId);

      return Right(favoriteShops);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
