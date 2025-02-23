import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class CancelAppointmentUseCase implements UseCase<void, String> {
  AppointmentsRepo appointmentsRepo;

  CancelAppointmentUseCase({required this.appointmentsRepo});

  @override
  Future<Either<Failure, void>> call(String params) async {
    return appointmentsRepo.cancelAppointment(params);
  }
}