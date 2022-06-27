import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/auth/data/datasources/local_token_datasource.dart';
import 'package:socnet/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/features/auth/data/models/token_model.dart';
import 'package:socnet/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

import '../../../../core/helpers/helpers.dart';

class MockLocalTokenDataSource extends Mock implements LocalTokenDataSource {}

class MockNetworkAuthDataSource extends Mock implements NetworkAuthDataSource {}

void main() {
  late MockLocalTokenDataSource mockLocalTokenDataSource;
  late MockNetworkAuthDataSource mockNetworkAuthDataSource;
  late AuthRepositoryImpl sut;

  setUp(() {
    mockLocalTokenDataSource = MockLocalTokenDataSource();
    mockNetworkAuthDataSource = MockNetworkAuthDataSource();
    sut = AuthRepositoryImpl(mockLocalTokenDataSource, mockNetworkAuthDataSource);
  });

  group('getToken', () {
    test(
      "should call local datasource and return the result if the call succeded",
      () async {
        // arrange
        const tToken = TokenModel(Token(token: "42"));
        when(() => mockLocalTokenDataSource.getToken()).thenAnswer((_) async => tToken);
        // act
        final result = await sut.getToken();
        // assert
        expect(result, Right(tToken.toEntity()));
        verify(() => mockLocalTokenDataSource.getToken());
        verifyNoMoreInteractions(mockLocalTokenDataSource);
        verifyZeroInteractions(mockNetworkAuthDataSource);
      },
    );
    test(
      "should return CacheFailure if call threw CacheException",
      () async {
        // arrange
        when(() => mockLocalTokenDataSource.getToken()).thenThrow(CacheException());
        // act
        final result = await sut.getToken();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
    test(
      "should return NoTokenFailure if call threw NoCallException",
      () async {
        // arrange
        when(() => mockLocalTokenDataSource.getToken()).thenThrow(NoTokenException());
        // act
        final result = await sut.getToken();
        // assert
        expect(result, Left(NoTokenFailure()));
      },
    );
  });

  void sharedLoginAndRegister({required bool isLogin}) {
    const tUsername = "username";
    const tPassword = "password";
    const tToken = Token(token: "42");
    const tTokenModel = TokenModel(tToken);
    test(
      "should call the network datasource, then store token in cache and return it, if everything is successful",
      () async {
        // arrange
        if (isLogin) {
          when(() => mockNetworkAuthDataSource.login(tUsername, tPassword))
              .thenAnswer((_) async => tTokenModel);
        } else {
          when(() => mockNetworkAuthDataSource.register(tUsername, tPassword))
              .thenAnswer((_) async => tTokenModel);
        }
        when(() => mockLocalTokenDataSource.storeToken(tTokenModel)).thenAnswer((_) async {});
        // act
        final result = isLogin
            ? await sut.login(tUsername, tPassword)
            : await sut.register(tUsername, tPassword);
        // assert
        expect(result, const Right(tToken));
        if (isLogin) {
          verify(() => mockNetworkAuthDataSource.login(tUsername, tPassword));
        } else {
          verify(() => mockNetworkAuthDataSource.register(tUsername, tPassword));
        }
        verify(() => mockLocalTokenDataSource.storeToken(tTokenModel));
        verifyNoMoreInteractions(mockNetworkAuthDataSource);
        verifyNoMoreInteractions(mockLocalTokenDataSource);
      },
    );
    test(
      "should return NetworkFailure if network datasource throws NetworkException",
      () async {
        // arrange
        final tException = randomNetworkException();
        if (isLogin) {
          when(() => mockNetworkAuthDataSource.login(tUsername, tPassword)).thenThrow(tException);
        } else {
          when(() => mockNetworkAuthDataSource.register(tUsername, tPassword))
              .thenThrow(tException);
        }
        // act
        final result = isLogin
            ? await sut.login(tUsername, tPassword)
            : await sut.register(tUsername, tPassword);
        // assert
        expect(result, Left(NetworkFailure(tException)));
      },
    );

    test(
      "should return CacheFailure if local datasource throws CacheException",
      () async {
        // arrange
        if (isLogin) {
          when(() => mockNetworkAuthDataSource.login(tUsername, tPassword))
              .thenAnswer((_) async => tTokenModel);
        } else {
          when(() => mockNetworkAuthDataSource.register(tUsername, tPassword))
              .thenAnswer((_) async => tTokenModel);
        }
        when(() => mockLocalTokenDataSource.storeToken(tTokenModel)).thenThrow(CacheException());
        // act
        final result = isLogin
            ? await sut.login(tUsername, tPassword)
            : await sut.register(tUsername, tPassword);
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  }

  group('login', () {
    sharedLoginAndRegister(isLogin: true);
  });

  group('register', () {
    sharedLoginAndRegister(isLogin: false);
  });

  group('logout', () {
    test(
      "should call local datasource and return void if everything was successful",
      () async {
        // arrange
        when(() => mockLocalTokenDataSource.deleteToken()).thenAnswer((_) async {});
        // act
        final result = await sut.logout();
        // assert
        expect(result, const Right(null));
        verify(() => mockLocalTokenDataSource.deleteToken());
        verifyNoMoreInteractions(mockLocalTokenDataSource);
        verifyZeroInteractions(mockNetworkAuthDataSource);
      },
    );
    test(
      "should return CacheFailure if local datasource throws CacheException",
      () async {
        // arrange
        when(() => mockLocalTokenDataSource.deleteToken()).thenThrow(CacheException());
        // act
        final result = await sut.logout();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });
}
