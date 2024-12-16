import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class GetAppointmentsUseCase implements StreamUseCase<void, String> {
  AppointmentsRepo appointmentRepo;

  GetAppointmentsUseCase({required this.appointmentRepo});

  @override
  Stream<Either<Failure, void>> call(String params) async* {
    yield* appointmentRepo.getAppointments(params);
  }
}
  

  