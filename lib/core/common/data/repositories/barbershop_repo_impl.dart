import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/datasources/barbershop_data_source.dart';
import 'package:uni_app/core/common/data/models/availability_model.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/common/domain/entities/appointment.dart';
import 'package:uni_app/core/common/domain/entities/availability.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/common/domain/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/exceptions.dart';
import 'package:uni_app/core/errors/failures.dart';

class BarbershopRepoImpl implements BarbershopRepo {
  final BarbershopDataSource barbershopDataSource;

  BarbershopRepoImpl({required this.barbershopDataSource});

  @override
  Future<Either<Failure, void>> addBarbershop(Barbershop barbershop) async {
    try {
      final result = await barbershopDataSource
          .addBarbershop(BarbershopModel.fromEntity(barbershop));
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBarbershop(String id) async {
    try {
      final result = await barbershopDataSource.deleteBarbershop(id);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Barbershop>> getBarbershop(String id) async {
    try {
      final result = await barbershopDataSource.getBarbershop(id);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Barbershop>>> getBarbershops() async {
    try {
      final result = await barbershopDataSource.getBarbershops();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBarbershop(Barbershop barbershop) async {
    try {
      final result = await barbershopDataSource
          .updateBarbershop(BarbershopModel.fromEntity(barbershop));
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> favoriteBarbershop(
      String userId, String barbershopId) async {
    try {
      final result =
          await barbershopDataSource.favoriteBarbershop(userId, barbershopId);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unfavoriteBarbershop(
      String userId, String barbershopId) async {
    try {
      final result =
          await barbershopDataSource.unfavoriteBarbershop(userId, barbershopId);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Availability>> streamAvailabilty(
      String shopId) async* {
    try {
      // if (!await networkInfo.isConnected) {
      //   yield Left(Failure('No internet connection'));
      //   return;
      // }

      final stream = barbershopDataSource.getMergedAvailabilityStream(shopId);
      await for (final availabilityModel in stream) {
        yield Right(availabilityModel);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Appointment>>> getAppointmentsStream(String shopId) async*{
    try {
      // if (!await networkInfo.isConnected) {
      //   yield Left(Failure('No internet connection'));
      //   return;
      // }

      final stream = barbershopDataSource.getAppointmentsStream(shopId);
      await for (final appointmentModel in stream) {
        yield Right(appointmentModel);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    }

  }
  
  @override
  Future<Either<Failure, void>> updateAvailability(Availability availability)async {
    try {
      final availabilityModel = AvailabilityModel.fromDomain(availability);
      final result = await barbershopDataSource.updateAvailability(availabilityModel);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
