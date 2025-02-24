import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for retrieving all barbershops.
class GetAllBarberShopsUseCase implements UseCase<List<Barbershop>, void> {
  final BarbershopRepo
      barbershopRepo; // Repository for managing barbershop data

  /// Creates a new instance of [GetAllBarberShopsUseCase].
  ///
  /// Requires an instance of [BarbershopRepo] to be provided.
  GetAllBarberShopsUseCase({required this.barbershopRepo});

  /// Retrieves all barbershops from the repository.
  ///
  /// Returns a [Future] of [Either<Failure, List<Barbershop>>], where:
  /// - [Failure] represents an error if one occurs,
  /// - [List<Barbershop>] contains the list of barbershops if successful.
  @override
  Future<Either<Failure, List<Barbershop>>> call(void params) async {
    return await barbershopRepo.getBarbershops();
  }
}
