import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/domain/datasources/local_token_datasource.dart';
import 'package:socnet/logic/features/auth/domain/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

import '../../../../../shared/helpers/base_tests.dart';
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
  });

  group("getToken()", () {
    baseRepositoryTests(
      () => sut.getToken(),
      () => mockLocalTokenDataSource.getToken(),
      "asdf",
      (result) => result == Token(token: "asdf"),
      () => mockLocalTokenDataSource,
    );
    test("should return NoTokenFailure if datasource returns null", () async {
      // arrange
      when(() => mockLocalTokenDataSource.getToken()).thenAnswer((_) async => null);
      // act
      final result = await sut.getToken();
      // assert
      expect(result, Left(NoTokenFailure()));
    });
  });

  group("getTokenStream()", () {
    test("should transform the local datasource stream", () async {
      // arrange
      final emitted = <Either<CacheFailure, String?>>[
        Right("abc"),
        Right(null),
        Right("asdf"),
        Right("cba"),
        Left(CacheFailure()),
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

  void sharedLoginAndRegister({required bool isLogin}) {
    const tUsername = "username";
    const tPassword = "password";
    const tToken = Token(token: "42");

    Future<Token> callNetwork() => isLogin
        ? mockNetworkAuthDataSource.login(tUsername, tPassword)
        : mockNetworkAuthDataSource.register(tUsername, tPassword);
    Future<void> callLocal() => mockLocalTokenDataSource.storeToken(tToken.token);
    Future<Either<Failure, void>> act() =>
        isLogin ? sut.login(tUsername, tPassword) : sut.register(tUsername, tPassword);

    test(
      "should call the network datasource, then store token in cache and return it, if everything is successful",
      () async {
        // arrange
        when(callNetwork).thenAnswer((_) async => tToken);
        when(callLocal).thenAnswer((_) async {});
        // act
        final result = await act();
        // assert
        expect(result, const Right(null));
        verify(callNetwork);
        verify(callLocal);
        verifyNoMoreInteractions(mockNetworkAuthDataSource);
        verifyNoMoreInteractions(mockLocalTokenDataSource);
      },
    );
    test(
      "should return NetworkFailure if network datasource throws",
      () async {
        // arrange
        final tFailure = randomNetworkFailure();
        when(callNetwork).thenThrow(tFailure);
        // act
        final result = await act();
        // assert
        expect(result, Left(tFailure));
      },
    );

    test(
      "should return CacheFailure if local datasource throws CacheException",
      () async {
        // arrange
        when(callNetwork).thenAnswer((_) async => tToken);
        when(callLocal).thenThrow(CacheFailure());
        // act
        final result = await act();
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
      "should return CacheFailure if local datasource throws",
      () async {
        // arrange
        when(() => mockLocalTokenDataSource.deleteToken()).thenThrow(CacheFailure());
        // act
        final result = await sut.logout();
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });
}
