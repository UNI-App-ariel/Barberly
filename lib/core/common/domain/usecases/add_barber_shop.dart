import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for adding a new barbershop.
class AddBarberShopUseCase implements UseCase<void, Barbershop> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [AddBarberShopUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  AddBarberShopUseCase({required this.barbershopRepo});

  /// Adds a new barbershop using the provided [Barbershop] object.
  ///
  /// Returns a [Future] of [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [void] indicates successful completion with no data returned.
  @override
  Future<Either<Failure, void>> call(Barbershop params) async {
    return await barbershopRepo.addBarbershop(params);
  }
}
