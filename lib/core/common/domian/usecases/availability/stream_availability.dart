import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/availability.dart';
import 'package:uni_app/core/common/domian/repositories/barbershop_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';

class StreamAvailabilityUseCase implements StreamUseCase<Availability, String> {
  final BarbershopRepo repository;

  StreamAvailabilityUseCase(this.repository);

  @override
  Stream<Either<Failure, Availability>> call(String params) async* {
    yield* repository.streamAvailabilty(params);
  }
}
