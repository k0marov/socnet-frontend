import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase extends UseCase<void, NoParams> {
  final AuthRepository _repository;
  LogoutUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return _repository.logout();
  }
}
