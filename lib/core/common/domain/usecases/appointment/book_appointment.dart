import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class BookAppointmentUseCase implements UseCase<void,Appointment>{
  AppointmentsRepo appointmentRepo;

  BookAppointmentUseCase({required this.appointmentRepo});
  
  @override
  Future<Either<Failure, void>> call(Appointment params) async {
    return appointmentRepo.bookAppointment(params);
  }
}