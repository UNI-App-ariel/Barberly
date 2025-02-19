import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class UpdateAvailabilityUsecase implements UseCase<void, Availability> {
  final BarbershopRepo repository;

  UpdateAvailabilityUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(Availability params) async{
    return await repository.updateAvailability(params);
  }
}
