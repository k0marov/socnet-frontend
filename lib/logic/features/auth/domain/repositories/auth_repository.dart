import 'package:dartz/dartz.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/helpers.dart';
import '../datasources/local_token_datasource.dart';
import '../datasources/network_auth_datasource.dart';

abstract class AuthRepository {
  /// failures: [CacheFailure], [NetworkFailure]
  Future<Either<Failure, void>> login(String username, String password);

  /// failures: [CacheFailure], [NetworkFailure]
  Future<Either<Failure, void>> register(String username, String password);

  /// failures: [CacheFailure]
  Future<Either<Failure, Token>> getToken();

  /// failures: [CacheFailure]
  Future<Either<Failure, void>> logout();

  Stream<Either<CacheFailure, Option<Token>>> getTokenStream();
}

class AuthRepositoryImpl implements AuthRepository {
  final LocalTokenDataSource _localDataSource;
  final NetworkAuthDataSource _networkDataSource;

  AuthRepositoryImpl(this._localDataSource, this._networkDataSource);

  @override
  Future<Either<Failure, Token>> getToken() async {
    return failureToLeft(() async {
      final token = await _localDataSource.getToken();
      if (token == null) throw NoTokenFailure();
      return Token(token: token);
    });
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
