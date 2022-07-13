import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../shared/fixtures/fixture_reader.dart';
import '../../shared/helpers/helpers.dart';

abstract class GetAuthToken {
  UseCaseReturn<Token> call();
}

class MockHttpClient extends Mock implements http.Client {}

class MockGetAuthToken extends Mock implements GetAuthToken {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockGetAuthToken mockGetAuthToken;
  late AuthenticatedAPIFacade sut;

  const tApiHost = "example.com";

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockGetAuthToken = MockGetAuthToken();
    sut = AuthenticatedAPIFacade(mockGetAuthToken, mockHttpClient, tApiHost);
  });
  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(http.Request("POST", Uri()));
  });

  const tToken = Token(token: "42");
  final tRightHeaders = {
    'Authorization': 'Token ' + tToken.token,
    'Accept': "application/json",
  };
  final tResponse = http.Response("", 200);

  void baseTestNoTokenException(Function act) {
    test(
      "should throw NoTokenException if called when token is null",
      () async {
        // arrange
        when(() => mockGetAuthToken()).thenAnswer((_) async => Left(CacheFailure()));
        // assert
        expect(act, throwsA(NoTokenFailure()));
      },
    );
  }

  void arrangeToken() {
    when(() => mockGetAuthToken()).thenAnswer((_) async => const Right(tToken));
  }

  group('get', () {
    final tEndpointQuery = getProfileEndpoint("42");
    baseTestNoTokenException(() => sut.get(tEndpointQuery));
    test(
      "should call http client with proper arguments and return the response",
      () async {
        // arrange
        arrangeToken();
        when(() => mockHttpClient.get(any(), headers: any(named: "headers"))).thenAnswer((_) async => tResponse);
        // act
        final result = await sut.get(tEndpointQuery);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.get(
            tEndpointQuery.toURL(tApiHost, true),
            headers: tRightHeaders,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('post', () {
    final tEndpointQuery = createPostEndpoint();
    final tBody = {'avatar': "testtesttest", 'something': 'value'};
    baseTestNoTokenException(() => sut.post(tEndpointQuery, tBody));
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        arrangeToken();
        when(
          () => mockHttpClient.post(
            any(),
            body: any(named: "body"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => tResponse);
        // act
        final result = await sut.post(tEndpointQuery, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.post(
            tEndpointQuery.toURL(tApiHost, true),
            body: json.encode(tBody),
            headers: tRightHeaders,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('delete', () {
    final tEndpointQuery = deletePostEndpoint("42");
    baseTestNoTokenException(() => sut.delete(tEndpointQuery));
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        arrangeToken();
        final tResponse = http.Response(randomString(), 4242);
        when(() => mockHttpClient.delete(any(), headers: any(named: "headers"))).thenAnswer((_) async => tResponse);
        // act
        final result = await sut.delete(tEndpointQuery);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.delete(
            tEndpointQuery.toURL(tApiHost, true),
            headers: tRightHeaders,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('put', () {
    final tEndpointQuery = updateAvatarEndpoint();
    final tBody = {'avatar': "testtesttest", 'something': 'value'};
    baseTestNoTokenException(() => sut.put(tEndpointQuery, tBody));
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        arrangeToken();
        when(
          () => mockHttpClient.put(
            any(),
            body: any(named: "body"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => tResponse);
        // act
        final result = await sut.put(tEndpointQuery, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.put(
            tEndpointQuery.toURL(tApiHost, true),
            headers: tRightHeaders,
            body: json.encode(tBody),
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('sendFiles', () {
    final tFile = fileFixture('avatar.png');
    const tFileField = 'avatar';
    final tFiles = {tFileField: fileFixture('avatar.png')};
    final tBody = {'about': 'New about'};
    const tMethod = "PUT";
    final tEndpointQuery = updateAvatarEndpoint();
    baseTestNoTokenException(() => sut.sendFiles(tMethod, tEndpointQuery, tFiles, tBody));
    test(
      "should call http client with proper args and return the result",
      () async {
        // arrange
        arrangeToken();
        when(() => mockHttpClient.send(any()))
            .thenAnswer((_) async => http.StreamedResponse(Stream.value([1, 2, 3]), 200));
        // act
        await sut.sendFiles(tMethod, tEndpointQuery, tFiles, tBody);
        // assert
        final capturedRequest = verify(() => mockHttpClient.send(captureAny())).captured[0] as http.MultipartRequest;
        expect(capturedRequest.files.length, tFiles.length);
        expect(capturedRequest.files.first.length, await File(tFile.path).length());
        expect(capturedRequest.files.first.field, tFileField);
        expect(capturedRequest.fields, tBody);
        expect(capturedRequest.url, tEndpointQuery.toURL(tApiHost, true));
        expect(capturedRequest.method, tMethod);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
}
