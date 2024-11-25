import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class GetBarberShopUseCase implements UseCase<Barbershop,String> {
  final BarbershopRepo barbershopRepo;

  GetBarberShopUseCase({required this.barbershopRepo});
  
  @override
  Future<Either<Failure, Barbershop>> call(String params) async{
    return await barbershopRepo.getBarbershop(params);
  }
}