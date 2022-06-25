import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:mocktail/mocktail.dart';

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
      const tToken = Token(token: "42");
      when(() => mockAuthRepository.getToken())
          .thenAnswer((_) async => const Right(tToken));
      // act
      final result = await sut(NoParams());
      // assert
      result.fold((failure) => throw AssertionError(),
          (token) => expect(identical(token, tToken), true));
      verify(() => mockAuthRepository.getToken());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
