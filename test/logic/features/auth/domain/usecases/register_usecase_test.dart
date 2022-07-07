import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/logic/features/auth/domain/usecases/register_usecase.dart';

import '../../../../../shared/helpers/helpers.dart';

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
      final tResult = Left<Failure, Token>(randomFailure());
      when(() => mockAuthRepository.register(tUsername, tPassword)).thenAnswer((_) async => tResult);
      // act
      final result = await sut(const RegisterParams(
        username: tUsername,
        password: tPassword,
      ));
      // assert
      expect(result, tResult);
      verify(() => mockAuthRepository.register(tUsername, tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
