import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for deleting a barbershop.
class DeleteBarberShopUseCase implements UseCase<void, String> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [DeleteBarberShopUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  DeleteBarberShopUseCase({required this.barbershopRepo});

  /// Deletes a barbershop identified by the provided [String] parameter.
  ///
  /// Returns a [Future] of [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [void] indicates successful completion with no data returned.
  @override
  Future<Either<Failure, void>> call(String params) async {
    return await barbershopRepo.deleteBarbershop(params);
  }
}
