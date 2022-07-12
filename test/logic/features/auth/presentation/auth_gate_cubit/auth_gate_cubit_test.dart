import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

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

    final sut = AuthGateCubit(() => Stream.fromIterable(tEvents));
    expect(sut.state, AuthState.loading);

    // assert later
    final wantEvents = [
      AuthState.unauthenticated,
      AuthState.authenticated,
      AuthState.failure,
      AuthState.authenticated,
    ];
    expect(sut.stream, emitsInOrder(wantEvents));
    // act
    sut.renewStream();
  });
}
