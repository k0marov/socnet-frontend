import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUseCase sut;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sut = RegisterUseCase(mockAuthRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      const tUsername = "username";
      const tPassword = "password";
      const tToken = Token(token: "42");
      when(() => mockAuthRepository.register(tUsername, tPassword))
          .thenAnswer((_) async => const Right(tToken));
      // act
      final result = await sut(const RegisterParams(
        username: tUsername,
        password: tPassword,
      ));
      // assert
      result.fold((failure) => throw AssertionError(),
          (token) => expect(identical(token, tToken), true));
      verify(() => mockAuthRepository.register(tUsername, tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
