import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/exception_to_failure.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_token_datasource.dart';
import '../models/token_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalTokenDataSource _localDataSource;
  final NetworkAuthDataSource _networkDataSource;

  AuthRepositoryImpl(this._localDataSource, this._networkDataSource);

  @override
  Future<Either<Failure, Token>> getToken() async {
    try {
      final cacheResponse = await _localDataSource.getToken();
      return Right(cacheResponse.toEntity());
    } on CacheException {
      return Left(CacheFailure());
    } on NoTokenException {
      return Left(NoTokenFailure());
    }
  }

  @override
  Future<Either<Failure, Token>> login(String username, String password) async {
    return _sharedLoginAndRegister(
      () async => _networkDataSource.login(
        username,
        password,
      ),
    );
  }

  @override
  Future<Either<Failure, Token>> register(String username, String password) async {
    return _sharedLoginAndRegister(
      () async => _networkDataSource.register(
        username,
        password,
      ),
    );
  }

  Future<Either<Failure, Token>> _sharedLoginAndRegister(
      Future<TokenModel> Function() networkLoginOrRegister) async {
    return exceptionToFailureCall(() async {
      final authToken = await networkLoginOrRegister();
      _localDataSource.storeToken(authToken);
      return authToken.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      _localDataSource.deleteToken();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
