import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domian/entities/barbershop.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';

class UpdateOwnerShopUseCase implements UseCase<void, Barbershop> {
  final OwnerShopRepo repository;

  UpdateOwnerShopUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Barbershop params) async {
    return await repository.updateOwnerShop(params);
  }
}
