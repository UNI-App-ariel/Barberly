import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class FavoriteShopUseCase implements UseCase<void, FavoriteShopParams> {
  final BarbershopRepo barbershopRepo;

  FavoriteShopUseCase({required this.barbershopRepo});

  @override
  Future<Either<Failure, void>> call(FavoriteShopParams params) async {
    return await barbershopRepo.favoriteBarbershop(
        params.userId, params.barbershopId);
  }
}

class UnFavoriteShopUseCase implements UseCase<void, FavoriteShopParams> {
  final BarbershopRepo barbershopRepo;

  UnFavoriteShopUseCase({required this.barbershopRepo});

  @override
  Future<Either<Failure, void>> call(FavoriteShopParams params) async {
    return await barbershopRepo.unfavoriteBarbershop(
        params.userId, params.barbershopId);
  }
}

class FavoriteShopParams {
  final String userId;
  final String barbershopId;

  FavoriteShopParams({required this.userId, required this.barbershopId});
}
