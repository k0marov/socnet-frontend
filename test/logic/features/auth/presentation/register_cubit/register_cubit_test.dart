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

PassStrength randomPassStrength() => PassStrength.values.elementAt(Random().nextInt(PassStrength.values.length));
RegisterState randomRegisterState() =>
    RegisterState(randomFieldValue(), randomFieldValue(), randomFieldValue(), randomPassStrength(), randomFailure());

void main() {
  final tNewPass = randomString();
  final tNewPassStrength = PassStrength.values.elementAt(Random().nextInt(PassStrength.values.length));

  late MockRegisterUseCase mockRegister;
  late MockAuthGateBloc mockAuthGate;
  late RegisterCubit sut;

  final tFilledState = randomRegisterState();

  final tUseCaseFailure = randomFailure();
  final tStateWithHandledFailure = randomRegisterState();

  setUp(() {
    mockRegister = MockRegisterUseCase();
    mockAuthGate = MockAuthGateBloc();
    sut = RegisterCubit(
      (pass) => pass == tNewPass ? tNewPassStrength : throw Exception(),
      mockRegister,
      (state, failure) =>
          state == tFilledState && failure == tUseCaseFailure ? tStateWithHandledFailure : throw Exception(),
      mockAuthGate,
    );
    registerFallbackValue(RegisterParams(username: "", password: ""));
  });

  const emptyState = RegisterState();

  test("should have initial state with empty fields", () async {
    expect(sut.state, emptyState);
  });

  void arrangeFilledState() => sut.emit(tFilledState);

  test("should set password AND password strength when passChanged() is invoked", () async {
    // arrange
    arrangeFilledState();
    // act
    sut.passChanged(tNewPass);
    // assert
    expect(
      sut.state,
      tFilledState.withPass(tFilledState.curPass.withValue(tNewPass)).withPassStrength(tNewPassStrength),
    );
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
      when(() => mockRegister(any())).thenAnswer((_) async => Left(tUseCaseFailure));
      // act
      await sut.registerPressed();
      // assert
      expect(sut.state, tStateWithHandledFailure);
      verifyZeroInteractions(mockAuthGate);
    });
  });
}
