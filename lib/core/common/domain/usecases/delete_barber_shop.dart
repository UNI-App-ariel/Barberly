import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class DeleteBarberShopUseCase implements UseCase<void,String> {
  final BarbershopRepo barbershopRepo;

  DeleteBarberShopUseCase({required this.barbershopRepo});

  @override
  Future<Either<Failure, void>> call(String params) async{
    return await barbershopRepo.deleteBarbershop(params);
  } 
}