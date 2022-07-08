import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockAuthGateBloc extends Mock implements AuthGateCubit {}

class MockLogin extends Mock implements LoginUseCase {}

LoginState randomLoginState() => LoginState(randomFieldValue(), randomFieldValue(), randomFailure());

void main() {
  late MockLogin mockLogin;
  late MockAuthGateBloc mockAuthGate;
  late LoginCubit sut;

  final tFilledState = randomLoginState();
  final tLoginFailure = randomFailure();
  final tStateWithHandledFailure = randomLoginState();

  setUp(() {
    mockAuthGate = MockAuthGateBloc();
    mockLogin = MockLogin();
    sut = LoginCubit(
      mockLogin,
      (state, failure) =>
          state == tFilledState && failure == tLoginFailure ? tStateWithHandledFailure : throw Exception(),
      mockAuthGate,
    );
    registerFallbackValue(LoginParams(username: "", password: ""));
  });

  const emptyState = LoginState(FieldValue(""), FieldValue(""));

  test("should have initial state with empty username and password and no failure", () async {
    expect(sut.state, emptyState);
    expect(sut.state.canBeSubmitted, false);
  });

  void arrangeFilledState() => sut.emit(tFilledState);

  test("should have canBeSubmitted = true if username and password are not empty", () async {
    // arrange
    sut.usernameChanged("a");
    sut.passwordChanged("a");
    // assert
    expect(sut.state.canBeSubmitted, true);
  });

  group("loginPressed", () {
    test("should do nothing if canBeSubmitted = false", () async {
      // act
      sut.loginPressed();
      // assert
      expect(sut.state, emptyState);
      verifyZeroInteractions(mockLogin);
      verifyZeroInteractions(mockAuthGate);
    });
    test("should call usecase and then auth gate if the call to usecase is successful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockLogin(any())).thenAnswer((_) async => Right(null));
      when(() => mockAuthGate.refreshState()).thenAnswer((_) async {});
      // act
      await sut.loginPressed();
      // assert
      expect(sut.state, tFilledState);
      verify(
          () => mockLogin(LoginParams(username: tFilledState.username.value, password: tFilledState.password.value)));
      verify(() => mockAuthGate.refreshState());
      verifyNoMoreInteractions(mockAuthGate);
    });
    test("should add failure to state if the call to usecase is unsuccessful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockLogin(any())).thenAnswer((_) async => Left(tLoginFailure));
      // act
      await sut.loginPressed();
      // assert
      expect(sut.state, tStateWithHandledFailure);
    });
  });
}
