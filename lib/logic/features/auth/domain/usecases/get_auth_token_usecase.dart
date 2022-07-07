import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

class GetAuthTokenUseCase extends UseCase<Token, NoParams> {
  final AuthRepository _repository;
  GetAuthTokenUseCase(this._repository);

  @override
  Future<Either<Failure, Token>> call(NoParams params) async {
    return _repository.getToken();
  }
}
