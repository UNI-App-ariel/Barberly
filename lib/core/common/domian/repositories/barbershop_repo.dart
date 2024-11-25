import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';

abstract interface class BarbershopRepo {
  Future<Either<Failure,List<Barbershop>>> getBarbershops();
  Future<Either<Failure,Barbershop>> getBarbershop(String id);
  Future<Either<Failure,void>> addBarbershop(Barbershop barbershop);
  Future<Either<Failure,void>> updateBarbershop(Barbershop barbershop);
  Future<Either<Failure,void>> deleteBarbershop(String id);
}