import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';

import '../../../../core/helpers/helpers.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetAuthTokenUseCase sut;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sut = GetAuthTokenUseCase(mockAuthRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      final tFailure = randomFailure();
      when(() => mockAuthRepository.getToken()).thenAnswer((_) async => Left(tFailure));
      // act
      final result = await sut(NoParams());
      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.getToken());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
