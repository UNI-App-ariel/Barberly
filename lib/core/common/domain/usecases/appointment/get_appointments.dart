import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class GetAppointmentsUseCase implements StreamUseCase<List<Appointment>, String> {
  AppointmentsRepo appointmentRepo;

  GetAppointmentsUseCase({required this.appointmentRepo});

  @override
  Stream<Either<Failure, List<Appointment>>> call(String params) async* {
    yield* appointmentRepo.getAppointments(params);
  }
}
  

  