import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';
import 'package:socnet/features/auth/presentation/auth/bloc/auth_page_bloc.dart';
import 'package:socnet/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';

class MockAuthGateBloc extends Mock implements AuthGateBloc {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late MockAuthGateBloc mockAuthGateBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late AuthPageBloc sut;

  setUp(() {
    mockAuthGateBloc = MockAuthGateBloc();
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    sut = AuthPageBloc(
      mockAuthGateBloc,
      mockLoginUseCase,
      mockRegisterUseCase,
    );
  });

  test(
    "should have initial state = AuthPageLogin",
    () async {
      // assert
      expect(sut.state, const AuthPageLogin());
    },
  );

  group('SwitchedToRegistration', () {
    test(
      "should set state to AuthPageRegistration",
      () async {
        // assert later
        expect(sut.stream, emitsInOrder([const AuthPageRegistration()]));
        // act
        sut.add(SwitchedToRegistration());
      },
    );
  });
  group('SwitchedToLogin', () {
    test(
      "should set state to AuthPageLogin",
      () async {
        // assert later
        expect(sut.stream, emitsInOrder([const AuthPageLogin()]));
        // act
        sut.add(SwitchedToLogin());
      },
    );
  });
  const tUsername = "username";
  const tPassword = "password";

  group('LoginRequested', () {
    const tLoginParams = LoginParams(username: tUsername, password: tPassword);
    test(
      "should call the login use case and also notify the auth gate if the call was successful",
      () async {
        // arrange
        when(() => mockLoginUseCase(tLoginParams)).thenAnswer((_) async => const Right(Token(token: "42")));
        when(() => mockAuthGateBloc.add(AuthStateUpdateRequested())).thenReturn(null);
        // act
        sut.add(const LoginRequested(username: tUsername, password: tPassword));
        // assert
        await untilCalled(() => mockAuthGateBloc.add(AuthStateUpdateRequested()));
        verify(() => mockLoginUseCase(tLoginParams));
        verify(() => mockAuthGateBloc.add(AuthStateUpdateRequested()));
        verifyNoMoreInteractions(mockLoginUseCase);
        verifyNoMoreInteractions(mockAuthGateBloc);
        verifyZeroInteractions(mockRegisterUseCase);
      },
    );
    test(
      "should set state to Loading when called",
      () async {
        // arrange
        when(() => mockLoginUseCase(tLoginParams)).thenAnswer((_) async => const Right(Token(token: "42")));
        when(() => mockAuthGateBloc.add(AuthStateUpdateRequested())).thenReturn(null);
        // assert later
        expect(sut.stream, emitsInOrder([const AuthPageLoading()]));
        // act
        sut.add(const LoginRequested(username: tUsername, password: tPassword));
      },
    );
    test(
      "should set state to [Loading, LoginFailure] if the call to use case returns failure",
      () async {
        // arrange
        when(() => mockLoginUseCase(tLoginParams)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              const AuthPageLoading(),
              AuthPageLoginFailure(
                username: tUsername,
                password: tPassword,
                failure: CacheFailure(),
              )
            ]));
        // act
        sut.add(const LoginRequested(username: tUsername, password: tPassword));
      },
    );
  });

  group('RegistrationRequested', () {
    const tRegisterParams = RegisterParams(username: tUsername, password: tPassword);
    test(
      "should validate the data, call the register usecase, and notify the auth gate if everything was successful",
      () async {
        // arrange
        when(() => mockRegisterUseCase(tRegisterParams)).thenAnswer((_) async => const Right(Token(token: '42')));
        when(() => mockAuthGateBloc.add(AuthStateUpdateRequested())).thenReturn(null);
        // act
        sut.add(const RegistrationRequested(username: tUsername, password: tPassword));
        // assert
        await untilCalled(() => mockAuthGateBloc.add(AuthStateUpdateRequested()));
        verify(() => mockRegisterUseCase(tRegisterParams));
        verify(() => mockAuthGateBloc.add(AuthStateUpdateRequested()));
        verifyNoMoreInteractions(mockRegisterUseCase);
        verifyNoMoreInteractions(mockAuthGateBloc);
        verifyZeroInteractions(mockLoginUseCase);
      },
    );
    test(
      "should set state to Loading at first",
      () async {
        // arrange
        when(() => mockRegisterUseCase(tRegisterParams)).thenAnswer((_) async => const Right(Token(token: '42')));
        when(() => mockAuthGateBloc.add(AuthStateUpdateRequested())).thenReturn(null);
        // assert later
        expect(sut.stream, emitsInOrder([const AuthPageLoading()]));
        // act
        sut.add(const RegistrationRequested(
          username: tUsername,
          password: tPassword,
        ));
      },
    );
    test(
      "should set state to AuthPageRegistrationFailure with proper failure if call to usecase failed",
      () async {
        // arrange
        when(() => mockRegisterUseCase(tRegisterParams)).thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        expect(
            sut.stream,
            emitsInOrder(
                [const AuthPageLoading(), AuthPageRegistrationFailure(username: tUsername, password: tPassword, failure: CacheFailure())]));
        // act
        sut.add(const RegistrationRequested(username: tUsername, password: tPassword));
      },
    );
  });
}
