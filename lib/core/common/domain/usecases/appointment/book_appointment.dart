import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/repositories/appointmet_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

/// A use case for booking an appointment.
class BookAppointmentUseCase implements UseCase<void, Appointment> {
  final AppointmentsRepo
      appointmentRepo; // Repository for managing appointments

  /// Creates a new instance of [BookAppointmentUseCase].
  ///
  /// Requires an instance of [AppointmentsRepo] to be provided.
  BookAppointmentUseCase({required this.appointmentRepo});

  /// Books an appointment using the provided [Appointment] parameters.
  ///
  /// Returns a [Future] that resolves to [Either<Failure, void>], where:
  /// - [Failure] represents an error if one occurs,
  /// - `void` indicates successful booking of the appointment.
  @override
  Future<Either<Failure, void>> call(Appointment params) async {
    return appointmentRepo.bookAppointment(params);
  }
}
