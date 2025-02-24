import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for favoriting a barbershop.
class FavoriteShopUseCase implements UseCase<void, FavoriteShopParams> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [FavoriteShopUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  FavoriteShopUseCase({required this.barbershopRepo});

  /// Favorites a barbershop for the user identified by [params].
  ///
  /// Returns a [Future] of [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [void] indicates successful completion with no data returned.
  @override
  Future<Either<Failure, void>> call(FavoriteShopParams params) async {
    return await barbershopRepo.favoriteBarbershop(
        params.userId, params.barbershopId);
  }
}

/// A use case for unfavoriting a barbershop.
class UnFavoriteShopUseCase implements UseCase<void, FavoriteShopParams> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [UnFavoriteShopUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  UnFavoriteShopUseCase({required this.barbershopRepo});

  /// Unfavorites a barbershop for the user identified by [params].
  ///
  /// Returns a [Future] of [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [void] indicates successful completion with no data returned.
  @override
  Future<Either<Failure, void>> call(FavoriteShopParams params) async {
    return await barbershopRepo.unfavoriteBarbershop(
        params.userId, params.barbershopId);
  }
}

/// Parameters required to favorite or unfavorite a barbershop.
class FavoriteShopParams {
  final String userId; // Unique identifier for the user
  final String barbershopId; // Unique identifier for the barbershop

  /// Creates a new instance of [FavoriteShopParams].
  ///
  /// Requires [userId] and [barbershopId] to be provided.
  FavoriteShopParams({required this.userId, required this.barbershopId});
}
