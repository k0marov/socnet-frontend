import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';

class MockLogout extends Mock implements LogoutUsecase {}

class MockGetAuthToken extends Mock implements GetAuthTokenUseCase {}

void main() {
  late MockLogout mockLogout;
  late MockGetAuthToken mockGetAuthToken;
  late AuthGateBloc sut;

  setUp(() {
    mockLogout = MockLogout();
    mockGetAuthToken = MockGetAuthToken();
    sut = AuthGateBloc(
      mockGetAuthToken,
      mockLogout,
    );
  });

  test(
    "should have initial state = AuthGateInitial",
    () async {
      // assert
      expect(sut.state, AuthGateInitial());
    },
  );
  group('LoggedOut', () {
    test(
      "should call logout usecase",
      () async {
        // arrange
        sut.emit(const AuthGateAuthenticated());
        when(() => mockLogout(NoParams())).thenAnswer((_) async => const Right(null));
        // act
        sut.add(LoggedOut());
        // assert
        await untilCalled(() => mockLogout(NoParams()));
        verify(() => mockLogout(NoParams()));
        verifyNoMoreInteractions(mockLogout);
      },
    );
    test(
      "should do nothing if emitted when state is not Authenticated",
      () async {
        fakeAsync((async) {
          // act
          sut.add(LoggedOut());
          // assert
          async.elapse(const Duration(seconds: 5));
          verifyZeroInteractions(mockLogout);
        });
      },
    );
    test(
      "should set state to Unauthenticated if logout is successful",
      () async {
        // arrange
        sut.emit(const AuthGateAuthenticated());
        when(() => mockLogout(NoParams())).thenAnswer((_) async => const Right(null));
        // assert later
        expect(sut.stream, emitsInOrder([const AuthGateUnauthenticated()]));
        // act
        sut.add(LoggedOut());
      },
    );
    test(
      "should set state to Authenticated with failure if logout is unsuccessful",
      () async {
        // arrange
        sut.emit(const AuthGateAuthenticated());
        when(() => mockLogout(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(sut.stream, emitsInOrder([AuthGateAuthenticated(CacheFailure())]));
        // act
        sut.add(LoggedOut());
        // assert
        await Future.delayed(const Duration(seconds: 2));
      },
    );
  });
  group('AuthStateUpdateRequested', () {
    test(
      "should call usecase",
      () async {
        // arrange
        const tToken = Token(token: '42');
        when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => const Right(tToken));
        // act
        sut.add(AuthStateUpdateRequested());
        // assert
        await untilCalled(() => mockGetAuthToken(NoParams()));
        verify(() => mockGetAuthToken(NoParams()));
      },
    );
    test(
      "should set state to Authenticated if usecase call is successful",
      () async {
        // arrange
        const tToken = Token(token: '42');
        when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => const Right(tToken));
        // assert later
        expect(sut.stream, emitsInOrder([const AuthGateAuthenticated()]));
        // act
        sut.add(AuthStateUpdateRequested());
      },
    );

    test(
      "should set state to Unauthenticated with failure if usecase returns failure",
      () async {
        // arrange
        when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(sut.stream, emitsInOrder([AuthGateUnauthenticated(CacheFailure())]));
        // act
        sut.add(AuthStateUpdateRequested());
      },
    );
  });
}
