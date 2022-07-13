import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';

import 'helpers.dart';

// TODO: testing rethrowing the MappingException

void baseNetworkDataSourceExceptionTests(
  Function() apiCall,
  Future Function() call,
) {
  test(
    "should throw proper NetworkException if status code != 200",
    () async {
      // arrange
      final tFailure = randomNetworkFailure();
      final tResponseBody = json.encode(tFailure.clientError?.toJson());
      when(apiCall).thenAnswer((_) async => http.Response(tResponseBody, tFailure.statusCode));
      // assert
      expect(call, throwsA(tFailure));
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
      final tFailure = randomFailure();
      when(dataSourceCall).thenThrow(tFailure);
      // act
      final result = await call();
      // assert
      expect(result, Left(tFailure));
    },
  );
  test("should return UnknownFailure if datasource call throws a non-Failure object", () async {
    // arrange
    const tThrown = "abc";
    when(dataSourceCall).thenThrow(tThrown);
    // act
    final result = await call();
    // assert
    expect(result, const Left(UnknownFailure(tThrown)));
  });
}
