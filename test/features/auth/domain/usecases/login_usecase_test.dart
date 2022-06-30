import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';

import '../../../../core/helpers/helpers.dart';

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
      final tResult = Left<Failure, Token>(randomFailure());
      when(() => mockAuthRepository.login(tUsername, tPassword)).thenAnswer((_) async => tResult);
      // act
      final result = await sut(const LoginParams(
        username: tUsername,
        password: tPassword,
      ));
      // assert
      expect(result, tResult);
      verify(() => mockAuthRepository.login(tUsername, tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
