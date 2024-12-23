import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/appointment.dart';
import 'package:uni_app/core/common/domian/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class UpdateAppointmentUseCase implements UseCase<void, Appointment> {
  final AppointmentsRepo repository;

  UpdateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Appointment params) async {
    return await repository.updateAppointment(params);
  }
}
