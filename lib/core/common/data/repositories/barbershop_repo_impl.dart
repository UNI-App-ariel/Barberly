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

/// BarbershopRepoImpl is the implementation of BarbershopRepo.
///
/// It uses BarbershopDataSource to interact with the data source
/// and map data to domain entities.
///
/// Parameters:
/// - [barbershopDataSource] is the data source instance.
class BarbershopRepoImpl implements BarbershopRepo {
  final BarbershopDataSource barbershopDataSource;

  BarbershopRepoImpl({required this.barbershopDataSource});

  /// Adds a new barbershop to the data source.
  ///
  /// Parameters:
  /// - [barbershop] is the barbershop to add.
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure.
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

  /// Deletes a barbershop from the data source.
  ///
  /// Parameters:
  /// - [id] is the `id` of the barbershop to delete.
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure.
  @override
  Future<Either<Failure, void>> deleteBarbershop(String id) async {
    try {
      final result = await barbershopDataSource.deleteBarbershop(id);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Retrieves a barbershop by its ID.
  ///
  /// Parameters:
  /// - [id] is the `id` of the barbershop to retrieve.
  ///
  /// Returns:
  /// - `Either<Failure, Barbershop>` is an `Either`
  ///   - `Right` contains the barbershop
  ///   - `Left` contains the failure.
  @override
  Future<Either<Failure, Barbershop>> getBarbershop(String id) async {
    try {
      final result = await barbershopDataSource.getBarbershop(id);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Retrieves a list of all barbershops.
  ///
  /// Returns:
  /// - `Either<Failure, List<Barbershop>>` is an `Either`
  ///   - `Right` contains the list of barbershops
  ///   - `Left` contains the failure.
  @override
  Future<Either<Failure, List<Barbershop>>> getBarbershops() async {
    try {
      final result = await barbershopDataSource.getBarbershops();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  /// Updates an existing barbershop in the data source.
  ///
  /// Parameters:
  /// - [barbershop] is the barbershop to update.
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure.
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

  /// Favorites a barbershop for a user.
  ///
  /// Parameters:
  /// - [userId] is the `id` of the user.
  /// - [barbershopId] is the `id` of the barbershop to favorite.
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure.
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

  /// Unfavorites a barbershop for a user.
  ///
  /// Parameters:
  /// - [userId] is the `id` of the user.
  /// - [barbershopId] is the `id` of the barbershop to unfavorite.
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure.
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

  /// Streams the availability for a given barbershop.
  ///
  /// Parameters:
  /// - [shopId] is the `id` of the barbershop.
  ///
  /// Returns:
  /// - `Stream<Either<Failure, Availability>>` is a stream of `Either`
  ///   - `Right` contains the availability data
  ///   - `Left` contains the failure.
  @override
  Stream<Either<Failure, Availability>> streamAvailabilty(
      String shopId) async* {
    try {
      final stream = barbershopDataSource.getMergedAvailabilityStream(shopId);
      await for (final availabilityModel in stream) {
        yield Right(availabilityModel);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    }
  }

  /// Streams the appointments for a given barbershop.
  ///
  /// Parameters:
  /// - [shopId] is the `id` of the barbershop.
  ///
  /// Returns:
  /// - `Stream<Either<Failure, List<Appointment>>>` is a stream of `Either`
  ///   - `Right` contains the list of appointments
  ///   - `Left` contains the failure.
  @override
  Stream<Either<Failure, List<Appointment>>> getAppointmentsStream(
      String shopId) async* {
    try {
      final stream = barbershopDataSource.getAppointmentsStream(shopId);
      await for (final appointmentModel in stream) {
        yield Right(appointmentModel);
      }
    } on ServerException catch (e) {
      yield Left(Failure(e.message));
    }
  }

  /// Updates the availability of a barbershop.
  ///
  /// Parameters:
  /// - [availability] is the new availability data to update.
  ///
  /// Returns:
  /// - `Either<Failure, void>` is an `Either`
  ///   - `Right` contains `null`
  ///   - `Left` contains the failure.
  @override
  Future<Either<Failure, void>> updateAvailability(
      Availability availability) async {
    try {
      final availabilityModel = AvailabilityModel.fromEntity(availability);
      final result =
          await barbershopDataSource.updateAvailability(availabilityModel);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
