import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/exception_to_failure.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

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
      final token = await _localDataSource.getToken();
      return Right(Token(token: token));
    } on CacheException {
      return Left(CacheFailure());
    } on NoTokenException {
      return Left(NoTokenFailure());
    }
  }

  @override
  Future<Either<Failure, void>> login(String username, String password) async {
    return _sharedLoginAndRegister(
      () async => _networkDataSource.login(
        username,
        password,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> register(String username, String password) async {
    return _sharedLoginAndRegister(
      () async => _networkDataSource.register(
        username,
        password,
      ),
    );
  }

  Future<Either<Failure, void>> _sharedLoginAndRegister(Future<TokenModel> Function() networkLoginOrRegister) async {
    return exceptionToFailureCall(() async {
      final authToken = await networkLoginOrRegister();
      _localDataSource.storeToken(authToken.toEntity().token);
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

  @override
  Stream<Either<CacheFailure, Option<Token>>> getTokenStream() => _localDataSource.getTokenStream().map(
        (event) => event.fold(
          (failure) => Left(CacheFailure()),
          (token) => Right(token != null ? Some(Token(token: token)) : const None()),
        ),
      );
}
