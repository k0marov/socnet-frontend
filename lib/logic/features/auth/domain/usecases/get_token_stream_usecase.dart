import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/usecase.dart';
import '../entities/token_entity.dart';

class GetTokenStreamUseCase {
  final AuthRepository _repo;
  const GetTokenStreamUseCase(this._repo);
  Stream<Either<CacheFailure, Option<Token>>> call(NoParams _) {
    return _repo.getTokenStream();
  }
}
