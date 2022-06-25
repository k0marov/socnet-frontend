import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LogoutUsecase sut;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sut = LogoutUsecase(mockAuthRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      const tReturn = Left(Failure());
      when(() => mockAuthRepository.logout()).thenAnswer((_) async => tReturn);
      // act
      final result = await sut(NoParams());
      // assert
      result.fold((failure) => expect(identical(tReturn, result), true),
          (_) => throw AssertionError());
      verify(() => mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
