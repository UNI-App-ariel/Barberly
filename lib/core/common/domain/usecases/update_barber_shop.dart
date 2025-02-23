import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class UpdateBarberShopUseCase implements UseCase<void, Barbershop> {
  final BarbershopRepo barbershopRepo;

  UpdateBarberShopUseCase({required this.barbershopRepo});
  
  @override
  Future<Either<Failure, void>> call(Barbershop params) async{
    return await barbershopRepo.updateBarbershop(params);
  }
}