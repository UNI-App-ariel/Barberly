import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/repositories/auth_repo.dart';

class LogOutUseCase implements UseCase<void, NoParams> {
  final AuthRepo repository;

  LogOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logOut();
  }
}
