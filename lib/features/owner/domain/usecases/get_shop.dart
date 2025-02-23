import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';

class GetOwnerShopUseCase implements StreamUseCase<Barbershop, String> {
  final OwnerShopRepo repository;

  GetOwnerShopUseCase(this.repository);

  @override
  Stream<Either<Failure, Barbershop>> call(String params) async* {
    yield* repository.getOwnerShop(params);
  }
}
