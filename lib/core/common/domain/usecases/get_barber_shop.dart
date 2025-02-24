import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for retrieving a specific barbershop by its ID.
class GetBarberShopUseCase implements UseCase<Barbershop, String> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [GetBarberShopUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  GetBarberShopUseCase({required this.barbershopRepo});

  /// Retrieves a barbershop by its ID from the repository.
  ///
  /// Returns a [Future] of [Either<Failure, Barbershop>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [Barbershop] contains the requested barbershop if successful.
  @override
  Future<Either<Failure, Barbershop>> call(String params) async {
    return await barbershopRepo.getBarbershop(params);
  }
}
