import 'package:fpdart/fpdart.dart';
import 'package:uni_app/core/common/domain/repositories/app_user_repo.dart';
import 'package:uni_app/core/errors/failures.dart';
import 'package:uni_app/core/usecase/usecase.dart';
import 'package:uni_app/features/auth/domain/entities/user.dart';

class StreamAppUserUseCase implements StreamUseCase<MyUser?, String> {
  final AppUserRepo repo;

  StreamAppUserUseCase({required this.repo});

  @override
  Stream<Either<Failure, MyUser?>> call(String params) async* {
    yield* repo.getUserStream(params);
  }
}
