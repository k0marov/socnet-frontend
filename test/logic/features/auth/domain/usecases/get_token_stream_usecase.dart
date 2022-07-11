import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_token_stream_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test("should forward the call to repo", () async {
    // arrange
    final mockRepo = MockAuthRepository();
    final tEvents = <Either<CacheFailure, Option<Token>>>[Left(CacheFailure()), Right(Some(Token(token: "42")))];
    final tStream = Stream.fromIterable(tEvents);
    when(() => mockRepo.getTokenStream()).thenAnswer((_) => tStream);
    // act
    final result = GetTokenStreamUseCase(mockRepo)(NoParams());
    // assert
    expect(result, emitsInOrder(tEvents));
  });
}
