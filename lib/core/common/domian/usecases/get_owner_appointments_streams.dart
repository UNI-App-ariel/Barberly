import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class GetOwnerAppointmentsStreamsUseCase
    implements StreamUseCase<List<Appointment>, String> {
  final BarbershopRepo barbershopRepo;

  GetOwnerAppointmentsStreamsUseCase({required this.barbershopRepo});

  @override
  Stream<Either<Failure, List<Appointment>>> call(String params) async* {
    yield* barbershopRepo.getAppointmentsStream(params);
  }
}
