import 'package:dartz/dartz.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  /// failures: [CacheFailure], [NetworkFailure]
  Future<Either<Failure, void>> login(String username, String password);

  /// failures: [CacheFailure], [NetworkFailure]
  Future<Either<Failure, void>> register(String username, String password);

  /// failures: [CacheFailure]
  Future<Either<Failure, Token>> getToken();

  /// failures: [CacheFailure]
  Future<Either<Failure, void>> logout();
}
