import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/domain/usecases/register_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockAuthGateBloc extends Mock implements AuthGateBloc {}

void main() {
  final tNewPass = randomString();
  final tNewPassStrength = PassStrength.values.elementAt(Random().nextInt(PassStrength.values.length));

  late MockRegisterUseCase mockRegister;
  late MockAuthGateBloc mockAuthGate;
  late RegisterCubit sut;
  setUp(() {
    mockRegister = MockRegisterUseCase();
    mockAuthGate = MockAuthGateBloc();
    sut = RegisterCubit(
      (pass) => pass == tNewPass ? tNewPassStrength : throw Exception(),
      mockRegister,
      mockAuthGate,
    );
    registerFallbackValue(RegisterParams(username: "", password: ""));
  });

  test("should have initial state with empty fields", () async {
    expect(sut.state, const RegisterState("", "", "", PassStrength.weak, null));
  });

  final tUsername = randomString();
  final tPass = randomString();
  final tPassRepeat = tPass;
  const tPassStrength = PassStrength.normal;
  final tFailure = randomFailure();
  final tFilledState = RegisterState(tUsername, tPass, tPassRepeat, tPassStrength, tFailure);

  final tNewUserame = randomString();
  final tNewPassRepeat = randomString();

  void arrangeFilledState() => sut.emit(tFilledState);

  test("should set username when usernameChanged() is invoked", () async {
    // arrange
    arrangeFilledState();
    // act
    sut.usernameChanged(tNewUserame);
    // assert
    expect(sut.state, RegisterState(tNewUserame, tPass, tPassRepeat, tPassStrength, tFailure));
  });
  test("should set password repeat when passRepeatChanged() is invoked", () async {
    // arrange
    arrangeFilledState();
    // act
    sut.passRepeatChanged(tNewPassRepeat);
    // assert
    expect(sut.state, RegisterState(tUsername, tPass, tNewPassRepeat, tPassStrength, tFailure));
  });
  test("should set password AND password strength when passChanged() is invoked", () async {
    // arrange
    arrangeFilledState();
    // act
    sut.passChanged(tNewPass);
    // assert
    expect(sut.state, RegisterState(tUsername, tNewPass, tPassRepeat, tNewPassStrength, tFailure));
  });
  group("registerPressed()", () {
    test("should call usecase and then call auth gate if usecase call was successful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockRegister(any())).thenAnswer((_) async => Right(null));
      when(() => mockAuthGate.add(AuthStateUpdateRequested())).thenReturn(null);
      // act
      await sut.registerPressed();
      // assert
      verify(() => mockAuthGate.add(AuthStateUpdateRequested()));
      verifyNoMoreInteractions(mockAuthGate);
    });
    test("should add failure to state if usecase call was unsuccessful", () async {
      // arrange
      arrangeFilledState();
      final tUseCaseFailure = randomFailure();
      when(() => mockRegister(any())).thenAnswer((_) async => Left(tUseCaseFailure));
      // act
      await sut.registerPressed();
      // assert
      expect(sut.state, RegisterState(tUsername, tPass, tPassRepeat, tPassStrength, tUseCaseFailure));
      verifyZeroInteractions(mockAuthGate);
    });
  });
}
