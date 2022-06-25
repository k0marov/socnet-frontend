import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'helpers.dart';

Future baseUseCaseTest<T>(
  Future<Either<Failure, T>> Function() useCaseCall,
  Future<Either<Failure, T>> Function() mockRepositoryCall,
  dynamic mockRepository,
) async {
  // arrange
  final tFailure = createTestFailure();
  when(mockRepositoryCall).thenAnswer((_) async => Left(tFailure));
  // act
  final result = await useCaseCall();
  // assert
  result.fold(
    (failure) => expect(identical(failure, tFailure), true),
    (success) => throw AssertionError(),
  );
  verify(mockRepositoryCall);
  verifyNoMoreInteractions(mockRepository);
}

void baseNetworkDataSourceExceptionTests(
  When Function() whenAPICall,
  Future Function() call,
) {
  test(
    "should rethrow NoTokenException",
    () async {
      // arrange
      whenAPICall().thenThrow(NoTokenException());
      // assert
      expect(call, throwsA(isA<NoTokenException>()));
    },
  );
  test(
    "should throw proper NetworkException if status code != 200",
    () async {
      // arrange
      const tCode = 4242;
      final tDetail = randomString();
      final tResponseBody = json.encode({'detail': tDetail});
      whenAPICall()
          .thenAnswer((_) async => http.Response(tResponseBody, tCode));
      // assert
      final exceptionMatcher =
          throwsA(equals(NetworkException(tCode, tDetail)));
      expect(call, exceptionMatcher);
    },
  );
  test(
    "should throw NetworkException.unknown() in case of other error",
    () async {
      // arrange
      whenAPICall().thenThrow(Exception());
      // act
      final exceptionMatcher =
          throwsA(equals(const NetworkException.unknown()));
      // assert
      expect(call, exceptionMatcher);
    },
  );
}

void baseRepositoryTests<DataSourceAnswer>(
    Future Function() call,
    dynamic Function() dataSourceCall,
    DataSourceAnswer dataSourceAnswer,
    bool Function(dynamic result) resultCheck,
    dynamic Function() getMockDataSource) async {
  test(
    "should call datasource and return the result if the call was successful",
    () async {
      // arrange
      when(dataSourceCall).thenAnswer((_) async => dataSourceAnswer);
      // act
      final result = await call();
      // assert
      result.fold(
        (failure) => throw AssertionError(),
        (rightResult) => expect(resultCheck(rightResult), true),
      );
      verify(dataSourceCall);
      verifyNoMoreInteractions(getMockDataSource());
    },
  );
  test(
    "should return proper failure if the call to datasource fails",
    () async {
      // arrange
      const tException = NetworkException(42, 'some detail');
      final tFailure = NetworkFailure.fromException(tException);
      when(dataSourceCall).thenThrow(tException);
      // act
      final result = await call();
      // assert
      expect(result, Left(tFailure));
    },
  );
  test(
    "should return NoTokenFailure if datasource throws NoTokenException",
    () async {
      // arrange
      when(dataSourceCall).thenThrow(NoTokenException());
      // act
      final result = await call();
      // assert
      expect(result, left(NoTokenFailure()));
    },
  );
}
