import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';

import '../fixtures/fixture_reader.dart';
import '../helpers/helpers.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockGetAuthToken extends Mock implements GetAuthTokenUseCase {}

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
        when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        // assert
        expect(act, throwsA(NoTokenException()));
      },
    );
  }

  void arrangeToken() {
    when(() => mockGetAuthToken(NoParams())).thenAnswer((_) async => Right(tToken));
  }

  group('get', () {
    const tEndpoint = "profiles-detail/1";
    const tBody = <String, String>{'something': 'value'};
    baseTestNoTokenException(() => sut.get(tEndpoint, tBody));
    test(
      "should call http client with proper arguments and return the response",
      () async {
        // arrange
        arrangeToken();
        when(() => mockHttpClient.get(any(), headers: any(named: "headers"))).thenAnswer((_) async => tResponse);
        // act
        final result = await sut.get(tEndpoint, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.get(
            Uri.https(tApiHost, tEndpoint, tBody),
            headers: tRightHeaders,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('post', () {
    const tEndpoint = "update-avatar/1234";
    final tBody = {'avatar': "testtesttest", 'something': 'value'};
    baseTestNoTokenException(() => sut.post(tEndpoint, tBody));
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
        final result = await sut.post(tEndpoint, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.post(
            Uri.https(tApiHost, tEndpoint),
            body: json.encode(tBody),
            headers: tRightHeaders,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('delete', () {
    final tEndpoint = randomString();
    baseTestNoTokenException(() => sut.delete(tEndpoint));
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        arrangeToken();
        final tResponse = http.Response(randomString(), 4242);
        when(() => mockHttpClient.delete(any(), headers: any(named: "headers"))).thenAnswer((_) async => tResponse);
        // act
        final result = await sut.delete(tEndpoint);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.delete(
            Uri.https(tApiHost, tEndpoint),
            headers: tRightHeaders,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('put', () {
    const tEndpoint = "update-avatar/1234";
    final tBody = {'avatar': "testtesttest", 'something': 'value'};
    baseTestNoTokenException(() => sut.put(tEndpoint, tBody));
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
        final result = await sut.put(tEndpoint, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.put(
            Uri.https(tApiHost, tEndpoint),
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
    const tEndpoint = "update-avatar/42";
    baseTestNoTokenException(() => sut.sendFiles(tMethod, tEndpoint, tFiles, tBody));
    test(
      "should call http client with proper args and return the result",
      () async {
        // arrange
        arrangeToken();
        when(() => mockHttpClient.send(any())).thenAnswer((_) async => http.StreamedResponse(Stream.value([1, 2, 3]), 200));
        // act
        await sut.sendFiles(tMethod, tEndpoint, tFiles, tBody);
        // assert
        final capturedRequest = verify(() => mockHttpClient.send(captureAny())).captured[0] as http.MultipartRequest;
        expect(capturedRequest.files.length, tFiles.length);
        expect(capturedRequest.files.first.length, await File(tFile.path).length());
        expect(capturedRequest.files.first.field, tFileField);
        expect(capturedRequest.fields, tBody);
        expect(capturedRequest.url, Uri.https(tApiHost, tEndpoint));
        expect(capturedRequest.method, tMethod);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
}
