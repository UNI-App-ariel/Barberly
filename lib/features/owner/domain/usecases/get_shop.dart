import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';

class GetOwnerShopUseCase implements UseCase<Barbershop, String> {
  final OwnerShopRepo repository;

  GetOwnerShopUseCase(this.repository);

  @override
  Future<Either<Failure, Barbershop>> call(String params) async {
    return await repository.getOwnerShop(params);
  }
}
