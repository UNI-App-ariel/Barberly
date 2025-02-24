import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for updating a barbershop's information.
class UpdateBarberShopUseCase implements UseCase<void, Barbershop> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [UpdateBarberShopUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  UpdateBarberShopUseCase({required this.barbershopRepo});

  /// Updates the information of a barbershop.
  ///
  /// Takes a [Barbershop] object as parameters and returns a [Future] that completes
  /// with either a [Failure] if an error occurs, or [void] if the update is successful.
  @override
  Future<Either<Failure, void>> call(Barbershop params) async {
    return await barbershopRepo.updateBarbershop(params);
  }
}
