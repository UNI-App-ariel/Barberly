import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class AddBarberShopUseCase implements UseCase<void, Barbershop> {
  final BarbershopRepo barbershopRepo;

  AddBarberShopUseCase({required this.barbershopRepo});

  @override
  Future<Either<Failure, void>> call(Barbershop params) async {
    return await barbershopRepo.addBarbershop(params);
  }
}
