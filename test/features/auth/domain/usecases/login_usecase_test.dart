import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase sut;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sut = LoginUseCase(mockAuthRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      const tUsername = "login";
      const tPassword = "password";
      const tToken = Token(token: "42");
      when(() => mockAuthRepository.login(tUsername, tPassword))
          .thenAnswer((_) async => const Right(tToken));
      // act
      final result = await sut(const LoginParams(
        username: tUsername,
        password: tPassword,
      ));
      // assert
      result.fold((failure) => throw AssertionError(),
          (token) => expect(identical(tToken, token), true));
      verify(() => mockAuthRepository.login(tUsername, tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
