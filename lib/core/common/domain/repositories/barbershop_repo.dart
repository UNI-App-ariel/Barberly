import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/entities/availability.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class BarbershopRepo {
  Future<Either<Failure,List<Barbershop>>> getBarbershops();
  Future<Either<Failure,Barbershop>> getBarbershop(String id);
  Future<Either<Failure,void>> addBarbershop(Barbershop barbershop);
  Future<Either<Failure,void>> updateBarbershop(Barbershop barbershop);
  Future<Either<Failure,void>> deleteBarbershop(String id);
  Future<Either<Failure,void>> favoriteBarbershop(String userId, String barbershopId);
  Future<Either<Failure,void>> unfavoriteBarbershop(String userId, String barbershopId);
  Stream<Either<Failure, Availability>> streamAvailabilty(String shopId);
  Stream<Either<Failure, List<Appointment>>> getAppointmentsStream(String shopId);
  Future<Either<Failure,void>> updateAvailability(Availability availability);
}