import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/data/datasources/local_token_datasource.dart';
import 'package:socnet/logic/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/data/models/token_model.dart';
import 'package:socnet/logic/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockLocalTokenDataSource extends Mock implements LocalTokenDataSource {}

class MockNetworkAuthDataSource extends Mock implements NetworkAuthDataSource {}

void main() {
  late MockLocalTokenDataSource mockLocalTokenDataSource;
  late MockNetworkAuthDataSource mockNetworkAuthDataSource;
  late AuthRepositoryImpl sut;

  setUp(() {
    mockLocalTokenDataSource = MockLocalTokenDataSource();
    mockNetworkAuthDataSource = MockNetworkAuthDataSource();
    sut = AuthRepositoryImpl(
      mockLocalTokenDataSource,
      mockNetworkAuthDataSource,
    );
    registerFallbackValue(const TokenModel(Token(token: "")));
  });

  group("getTokenStream()", () {
    test("should transform the local datasource stream", () async {
      // arrange
      final emitted = <Either<CacheException, String?>>[
        Right("abc"),
        Right(null),
        Right("asdf"),
        Right("cba"),
        Left(CacheException())
      ];
      final stream = Stream.fromIterable(emitted);
      when(() => mockLocalTokenDataSource.getTokenStream()).thenAnswer((_) => stream);
      // act
      final gotStream = sut.getTokenStream();
      // assert
      final wantTransformed = [
        Right(Some(Token(token: "abc"))),
        Right(None()),
        Right(Some(Token(token: "asdf"))),
        Right(Some(Token(token: "cba"))),
        Left(CacheFailure()),
      ];
      expect(gotStream, emitsInOrder(wantTransformed));
    });
  });

  group('getToken', () {
    test(
      "should call local datasource and return the result if the call succeded",
      () async {
        // arrange
        final tToken = randomString();
        when(() => mockLocalTokenDataSource.getToken()).thenAnswer((_) async => tToken);
        // act
        final result = await sut.getToken();
        // assert
        expect(result, Right(Token(token: tToken)));
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
    const tTokenModel = TokenModel(Token(token: "42"));
    test(
      "should call the network datasource, then store token in cache and return it, if everything is successful",
      () async {
        // arrange
        if (isLogin) {
          when(() => mockNetworkAuthDataSource.login(any(), any())).thenAnswer((_) async => tTokenModel);
        } else {
          when(() => mockNetworkAuthDataSource.register(any(), any())).thenAnswer((_) async => tTokenModel);
        }
        when(() => mockLocalTokenDataSource.storeToken(any())).thenAnswer((_) async {});
        // act
        final result = isLogin ? await sut.login(tUsername, tPassword) : await sut.register(tUsername, tPassword);
        // assert
        expect(result, const Right(null));
        if (isLogin) {
          verify(() => mockNetworkAuthDataSource.login(tUsername, tPassword));
        } else {
          verify(() => mockNetworkAuthDataSource.register(tUsername, tPassword));
        }
        verify(() => mockLocalTokenDataSource.storeToken(tTokenModel.toEntity().token));
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
          when(() => mockNetworkAuthDataSource.login(any(), any())).thenThrow(tException);
        } else {
          when(() => mockNetworkAuthDataSource.register(any(), any())).thenThrow(tException);
        }
        // act
        final result = isLogin ? await sut.login(tUsername, tPassword) : await sut.register(tUsername, tPassword);
        // assert
        expect(result, Left(NetworkFailure(tException)));
      },
    );

    test(
      "should return CacheFailure if local datasource throws CacheException",
      () async {
        // arrange
        if (isLogin) {
          when(() => mockNetworkAuthDataSource.login(any(), any())).thenAnswer((_) async => tTokenModel);
        } else {
          when(() => mockNetworkAuthDataSource.register(any(), any())).thenAnswer((_) async => tTokenModel);
        }
        when(() => mockLocalTokenDataSource.storeToken(any())).thenThrow(CacheException());
        // act
        final result = isLogin ? await sut.login(tUsername, tPassword) : await sut.register(tUsername, tPassword);
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

  // group('logout', () {
  //   test(
  //     "should call local datasource and return void if everything was successful",
  //     () async {
  //       // arrange
  //       when(() => mockLocalTokenDataSource.deleteToken()).thenAnswer((_) async {});
  //       // act
  //       final result = await sut.logout();
  //       // assert
  //       expect(result, const Right(null));
  //       verify(() => mockLocalTokenDataSource.deleteToken());
  //       verifyNoMoreInteractions(mockLocalTokenDataSource);
  //       verifyZeroInteractions(mockNetworkAuthDataSource);
  //     },
  //   );
  //   test(
  //     "should return CacheFailure if local datasource throws CacheException",
  //     () async {
  //       // arrange
  //       when(() => mockLocalTokenDataSource.deleteToken()).thenThrow(CacheException());
  //       // act
  //       final result = await sut.logout();
  //       // assert
  //       expect(result, Left(CacheFailure()));
  //     },
  //   );
  // });
}
