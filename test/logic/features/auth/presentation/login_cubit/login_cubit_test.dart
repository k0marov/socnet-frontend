import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockAuthGateBloc extends Mock implements AuthGateBloc {}

class MockLogin extends Mock implements LoginUseCase {}

void main() {
  late MockLogin mockLogin;
  late MockAuthGateBloc mockAuthGate;
  late LoginCubit sut;

  setUp(() {
    mockAuthGate = MockAuthGateBloc();
    mockLogin = MockLogin();
    sut = LoginCubit(mockLogin, mockAuthGate);
    registerFallbackValue(LoginParams(username: "", password: ""));
  });

  test("should have initial state with empty username and password and no failure", () async {
    expect(sut.state, const LoginState("", ""));
  });

  final tUsername = randomString();
  final tNewUsername = randomString();
  final tPassword = randomString();
  final tNewPassword = randomString();
  final tFailure = randomFailure();

  final tFilledState = LoginState(tUsername, tPassword, tFailure);
  void arrangeFilledState() => sut.emit(tFilledState);

  void arrangeAuthGate() => when(() => mockAuthGate.add(AuthStateUpdateRequested())).thenAnswer((_) {});
  void verifyAuthGateCalled() {
    verify(() => mockAuthGate.add(AuthStateUpdateRequested()));
    verifyNoMoreInteractions(mockAuthGate);
  }

  test("should update username when usernameChanged() is invoked", () async {
    // arrange
    arrangeFilledState();
    // act
    sut.usernameChanged(tNewUsername);
    // assert
    expect(sut.state, LoginState(tNewUsername, tPassword, tFailure));
  });
  test("should update password when passwordChanged() is invoked", () async {
    // arrange
    arrangeFilledState();
    // act
    sut.passwordChanged(tNewPassword);
    // assert
    expect(sut.state, LoginState(tUsername, tNewPassword, tFailure));
  });

  group("loginPressed", () {
    test("should call usecase and then auth gate if the call to usecase is successful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockLogin(any())).thenAnswer((_) async => Right(null));
      arrangeAuthGate();
      // act
      await sut.loginPressed();
      // assert
      expect(sut.state, tFilledState);
      verify(() => mockLogin(LoginParams(username: tUsername, password: tPassword)));
      verifyAuthGateCalled();
    });
    test("should add failure to state if the call to usecase is unsuccessful", () async {
      // arrange
      final tNewFailure = randomFailure();
      arrangeFilledState();
      when(() => mockLogin(any())).thenAnswer((_) async => Left(tNewFailure));
      // act
      await sut.loginPressed();
      // assert
      expect(sut.state, LoginState(tUsername, tPassword, tNewFailure));
    });
  });
}
