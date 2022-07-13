import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/error/helpers.dart';
import 'package:socnet/logic/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_token_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalTokenDataSource _localDataSource;
  final NetworkAuthDataSource _networkDataSource;

  AuthRepositoryImpl(this._localDataSource, this._networkDataSource);

  @override
  Future<Either<Failure, Token>> getToken() async {
    final firstEvent = await _localDataSource.getTokenStream().first;
    return firstEvent.fold(
      (failure) => Left(failure),
      (token) => token != null ? Right(Token(token: token)) : Left(NoTokenFailure()),
    );
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

  Future<Either<Failure, void>> _sharedLoginAndRegister(Future<Token> Function() networkLoginOrRegister) async {
    return failureToLeft(() async {
      final authToken = await networkLoginOrRegister();
      _localDataSource.storeToken(authToken.token);
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return failureToLeft(_localDataSource.deleteToken);
  }

  @override
  Stream<Either<CacheFailure, Option<Token>>> getTokenStream() => _localDataSource.getTokenStream().map(
        (event) => event.flatMap(
          (token) => Right(token != null ? Some(Token(token: token)) : const None()),
        ),
      );
}
