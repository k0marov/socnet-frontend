import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockLogout extends Mock implements LogoutUsecase {}

class MockGetAuthToken extends Mock implements GetAuthTokenUseCase {}

void main() {
  late MockLogout mockLogout;
  late MockGetAuthToken mockGetAuthToken;
  late AuthGateCubit sut;

  setUp(() {
    mockLogout = MockLogout();
    mockGetAuthToken = MockGetAuthToken();
    sut = AuthGateCubit(
      mockGetAuthToken,
      mockLogout,
    );
  });

  const emptyState = AuthState(false, null);

  test(
    "should have initial state = AuthGateInitial",
    () async {
      // assert
      expect(sut.state, emptyState);
    },
  );

  final tFilledState = AuthState(randomBool(), randomFailure());
  void arrangeFilledState() => sut.emit(tFilledState);

  group('logout', () {
    test("should call logout usecase and set state to unauthenticated without failure if it was successful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockLogout(NoParams())).thenAnswer((_) async => Right(null));
      // act
      await sut.logout();
      // assert
      expect(sut.state, tFilledState.withoutFailure().withAuthenticated(false));
    });
    test("should add failure to state if usecase call was unsuccessful", () async {
      // arrange
      arrangeFilledState();
      final tFailure = randomFailure();
      when(() => mockLogout(NoParams())).thenAnswer((_) async => Left(tFailure));
      // act
      await sut.logout();
      // assert
      expect(sut.state, tFilledState.withFailure(tFailure));
    });
  });
  group("refreshState", () {
    test("should call get token usecase and set state to authenticated without failure if call succeeds", () async {
      // arrange
      arrangeFilledState();
      when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => Right(Token(token: randomString())));
      // act
      await sut.refreshState();
      // assert
      expect(sut.state, tFilledState.withoutFailure().withAuthenticated(true));
    });
    test("should set state to unauthenticated without failure if call returns NoTokenFailure", () async {
      // arrange
      arrangeFilledState();
      when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => Left(NoTokenFailure()));
      // act
      await sut.refreshState();
      // assert
      expect(sut.state, tFilledState.withoutFailure().withAuthenticated(false));
    });
    test("should set state to unauthenticated with failure if call returns some other Failure", () async {
      // arrange
      arrangeFilledState();
      final tFailure = randomFailure();
      when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => Left(tFailure));
      // act
      await sut.refreshState();
      // assert
      expect(sut.state, tFilledState.withAuthenticated(false).withFailure(tFailure));
    });
  });
}
