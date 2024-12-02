import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/data/datasources/barbershop_data_source.dart';
import 'package:uni_app/core/common/data/models/barbershop_model.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';

class BarbershopRepoImpl implements BarbershopRepo {
  final BarbershopDataSource barbershopDataSource;

  BarbershopRepoImpl({required this.barbershopDataSource});

  @override
  Future<Either<Failure, void>> addBarbershop(Barbershop barbershop) async {
    try{
      final result = await barbershopDataSource.addBarbershop(BarbershopModel.fromEntity(barbershop));
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBarbershop(String id) async {
    try{
      final result = await barbershopDataSource.deleteBarbershop(id);
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Barbershop>> getBarbershop(String id) async {
    try{
      final result = await barbershopDataSource.getBarbershop(id);
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Barbershop>>> getBarbershops() async{
    try{
      final result = await barbershopDataSource.getBarbershops();
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBarbershop(Barbershop barbershop) async{
    try{
      final result = await barbershopDataSource.updateBarbershop(BarbershopModel.fromEntity(barbershop));
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> favoriteBarbershop(String userId, String barbershopId) async {
    try{
      final result = await barbershopDataSource.favoriteBarbershop(userId, barbershopId);
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> unfavoriteBarbershop(String userId, String barbershopId) async {
    try{
      final result = await barbershopDataSource.unfavoriteBarbershop(userId, barbershopId);
      return Right(result);
    } catch(e) {
      return Left(Failure(e.toString()));
    }
  }
}