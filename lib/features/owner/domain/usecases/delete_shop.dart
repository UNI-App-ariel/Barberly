import 'package:fpdart/fpdart.dart';

import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/owner/domain/repositories/owner_shop_repo.dart';

class DeleteOwnerShopUseCase implements UseCase<void, String> {
  final OwnerShopRepo repository;

  DeleteOwnerShopUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteOwnerShop(params);
  }
}
