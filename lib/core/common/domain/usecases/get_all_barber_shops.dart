import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class GetAllBarberShopsUseCase implements UseCase<List<Barbershop>, void> {
  final BarbershopRepo barbershopRepo;

  GetAllBarberShopsUseCase({required this.barbershopRepo});

  @override
  Future<Either<Failure, List<Barbershop>>> call(void params) async {
    return await barbershopRepo.getBarbershops();
  }
}
