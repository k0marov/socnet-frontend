import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockLogout extends Mock implements LogoutUsecase {}

class MockGetAuthToken extends Mock implements GetAuthTokenUseCase {}

class MockAuthenticatedAPIFacade extends Mock
    implements AuthenticatedAPIFacade {}

void main() {
  late MockLogout mockLogout;
  late MockGetAuthToken mockGetAuthToken;
  late MockAuthenticatedAPIFacade mockAuthenticatedAPIFacade;
  late AuthGateBloc sut;

  setUp(() {
    mockLogout = MockLogout();
    mockAuthenticatedAPIFacade = MockAuthenticatedAPIFacade();
    mockGetAuthToken = MockGetAuthToken();
    sut = AuthGateBloc(
      mockGetAuthToken,
      mockLogout,
      mockAuthenticatedAPIFacade,
    );
  });

  test(
    "should have initial state = SplashScreenInitial",
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
        when(() => mockLogout(NoParams()))
            .thenAnswer((_) async => const Right(null));
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
          verifyZeroInteractions(mockAuthenticatedAPIFacade);
        });
      },
    );
    test(
      "should set state to Unauthenticated and set token to null in api facade if logout is successful",
      () async {
        // arrange
        sut.emit(const AuthGateAuthenticated());
        when(() => mockLogout(NoParams()))
            .thenAnswer((_) async => const Right(null));
        // assert later
        expect(sut.stream, emitsInOrder([const AuthGateUnauthenticated()]));
        // act
        sut.add(LoggedOut());
        // assert
        await untilCalled(() => mockAuthenticatedAPIFacade.setToken(null));
        verify(() => mockAuthenticatedAPIFacade.setToken(null));
        verifyNoMoreInteractions(mockAuthenticatedAPIFacade);
      },
    );
    test(
      "should set state to Authenticated with failure and don't update the token in api facade if logout is unsuccessful",
      () async {
        // arrange
        sut.emit(const AuthGateAuthenticated());
        when(() => mockLogout(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(
            sut.stream, emitsInOrder([AuthGateAuthenticated(CacheFailure())]));
        // act
        sut.add(LoggedOut());
        // assert
        await Future.delayed(const Duration(seconds: 2));
        verifyZeroInteractions(mockAuthenticatedAPIFacade);
      },
    );
  });
  group('AuthStateUpdateRequested', () {
    test(
      "should call usecase",
      () async {
        // arrange
        const tToken = Token(token: '42');
        when(() => mockGetAuthToken(NoParams()))
            .thenAnswer((_) async => const Right(tToken));
        // act
        sut.add(AuthStateUpdateRequested());
        // assert
        await untilCalled(() => mockGetAuthToken(NoParams()));
        verify(() => mockGetAuthToken(NoParams()));
      },
    );
    test(
      "should set state to Authenticated and update the token in the api facade if usecase call is successful",
      () async {
        // arrange
        const tToken = Token(token: '42');
        when(() => mockGetAuthToken(NoParams()))
            .thenAnswer((_) async => const Right(tToken));
        // assert later
        expect(sut.stream, emitsInOrder([const AuthGateAuthenticated()]));
        // act
        sut.add(AuthStateUpdateRequested());
        // assert
        await untilCalled(
          () => mockAuthenticatedAPIFacade.setToken(tToken),
        );
        verify(
          () => mockAuthenticatedAPIFacade.setToken(tToken),
        );
      },
    );

    test(
      "should set state to Unauthenticated with failure and set token in api facade to null if usecase returns failure",
      () async {
        // arrange
        when(() => mockGetAuthToken(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(sut.stream,
            emitsInOrder([AuthGateUnauthenticated(CacheFailure())]));
        // act
        sut.add(AuthStateUpdateRequested());
        // assert
        await untilCalled(() => mockAuthenticatedAPIFacade.setToken(null));
        verify(() => mockAuthenticatedAPIFacade.setToken(null));
      },
    );
  });
}
