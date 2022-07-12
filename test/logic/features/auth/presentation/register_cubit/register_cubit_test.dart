import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

abstract class Register {
  UseCaseReturn<void> call(String username, String password);
}

class MockRegisterUseCase extends Mock implements Register {}

RegisterState randomRegisterState() {
  final pass = randomFieldValue();
  return RegisterState(randomFieldValue(), pass, pass, PassStrength.normal, randomFailure());
}

void main() {
  final tNewPass = randomString();
  const tNewPassStrength = PassStrength.normal;

  late MockRegisterUseCase mockRegister;
  late RegisterCubit sut;

  final tFilledState = randomRegisterState();

  final tUseCaseFailure = randomFailure();
  final tStateWithHandledFailure = randomRegisterState();

  setUp(() {
    mockRegister = MockRegisterUseCase();
    sut = RegisterCubit(
      (pass) => pass == tNewPass ? tNewPassStrength : throw Exception(),
      mockRegister,
      (state, failure) => state == tFilledState.withoutFailures() && failure == tUseCaseFailure
          ? tStateWithHandledFailure
          : throw Exception(),
    );
  });

  const emptyState = RegisterState();

  test("should have initial state with empty fields", () async {
    expect(sut.state, emptyState);
    expect(sut.state.canBeSubmitted, false);
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
      tFilledState.withPass(tFilledState.pass.withValue(tNewPass)).withPassStrength(tNewPassStrength),
    );
    expect(sut.state.canBeSubmitted, true);
  });
  group("registerPressed()", () {
    test("should do nothing if canBeSubmitted = false", () async {
      // act
      await sut.registerPressed();
      // assert
      expect(sut.state, emptyState);
      verifyZeroInteractions(mockRegister);
    });
    test("should replace all failures with specific failure and not call anything if passwords don't match", () async {
      // arrange
      final tRandomPassRepeat = randomString();
      arrangeFilledState();
      sut.passRepeatChanged(tRandomPassRepeat);
      // act
      await sut.registerPressed();
      // assert
      final wantState =
          tFilledState.withoutFailures().withPassRepeat(FieldValue(tRandomPassRepeat, passwordsDontMatch));
      expect(sut.state, wantState);
      verifyZeroInteractions(mockRegister);
    });
    test("should call usecase, clear all failures and then call auth gate if usecase call was successful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockRegister(tFilledState.username.value, tFilledState.pass.value))
          .thenAnswer((_) async => Right(null));
      // act
      await sut.registerPressed();
      // assert
      expect(sut.state, tFilledState.withoutFailures());
    });
    test("should replace all failures with the returned failure if usecase call was unsuccessful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockRegister(any(), any())).thenAnswer((_) async => Left(tUseCaseFailure));
      // act
      await sut.registerPressed();
      // assert
      expect(sut.state, tStateWithHandledFailure);
    });
  });
}
