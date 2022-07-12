import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

import '../entities/token_entity.dart';

typedef GetTokenStreamUseCase = Stream<Either<CacheFailure, Option<Token>>> Function();

GetTokenStreamUseCase newGetTokenStreamUseCase(AuthRepository repo) => () => repo.getTokenStream();
