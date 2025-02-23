
import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/customer/domain/repsitories/favorites_repo.dart';
// class returns fav shops
class GetFavoriteShopsUseCase implements UseCase<List<Barbershop>, String> {
  final FavoritesRepo favoritesRepo;

  GetFavoriteShopsUseCase({required this.favoritesRepo});

  @override
  Future<Either<Failure, List<Barbershop>>> call(String params) async {
    return await favoritesRepo.getFavoriteShops(params);
  }
}
