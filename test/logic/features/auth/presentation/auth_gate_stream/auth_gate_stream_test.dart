import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_token_stream_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate_stream/auth_gate_stream.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockGetTokenStreamUseCase extends Mock implements GetTokenStreamUseCase {}

void main() {
  test("should properly transform the auth token stream", () async {
    // arrange
    final tToken = Token(token: randomString());
    final tEvents = <Either<CacheFailure, Option<Token>>>[
      Right(None()),
      Right(Some(tToken)),
      Right(Some(tToken)),
      Left(CacheFailure()),
      Right(Some(tToken))
    ];
    final mockUsecase = MockGetTokenStreamUseCase();
    when(() => mockUsecase(NoParams())).thenAnswer((_) => Stream.fromIterable(tEvents));
    // act
    final gotStream = AuthGateStreamFactory(mockUsecase);
    // assert
    final wantEvents = [
      AuthState(false),
      AuthState(true),
      AuthState(true),
      AuthState(false, CacheFailure()),
      AuthState(true)
    ];
    expect(gotStream, emitsInOrder(wantEvents));
  });
}
