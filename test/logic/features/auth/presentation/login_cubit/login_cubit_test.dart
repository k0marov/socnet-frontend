import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

abstract class Login {
  UseCaseReturn<void> call(String username, String password);
}

class MockLogin extends Mock implements Login {}

LoginState randomLoginState() => LoginState(randomFieldValue(), randomFieldValue(), randomFailure());

void main() {
  late MockLogin mockLogin;
  late LoginCubit sut;

  final tFilledState = randomLoginState();
  final tLoginFailure = randomFailure();
  final tStateWithHandledFailure = randomLoginState();

  setUp(() {
    mockLogin = MockLogin();
    sut = LoginCubit(
      mockLogin,
      (state, failure) => state == tFilledState.withoutFailures() && failure == tLoginFailure
          ? tStateWithHandledFailure
          : throw Exception(),
    );
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
      await sut.loginPressed();
      // assert
      expect(sut.state, emptyState);
      verifyZeroInteractions(mockLogin);
    });
    test("should call usecase, remove all failures from state if the call to usecase is successful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockLogin(tFilledState.username.value, tFilledState.password.value))
          .thenAnswer((_) async => Right(null));
      // act
      await sut.loginPressed();
      // assert
      expect(sut.state, tFilledState.withoutFailures());
    });
    test("should replace all failures with the new failure if the call to usecase is unsuccessful", () async {
      // arrange
      arrangeFilledState();
      when(() => mockLogin(any(), any())).thenAnswer((_) async => Left(tLoginFailure));
      // act
      await sut.loginPressed();
      // assert
      expect(sut.state, tStateWithHandledFailure);
    });
  });
}
