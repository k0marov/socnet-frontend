import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/api.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../fixtures/fixture_reader.dart';
import '../helpers/helpers.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late AuthenticatedAPIFacade sut;

  setUp(() {
    mockHttpClient = MockHttpClient();
    sut = AuthenticatedAPIFacade(mockHttpClient);
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

  group('get', () {
    const tEndpoint = "profiles-detail/1";
    const tBody = <String, dynamic>{'something': 'value'};
    test(
      "should throw NoTokenException if called when token is null",
      () async {
        // assert
        expect(() => sut.get(tEndpoint, tBody),
            throwsA(const TypeMatcher<NoTokenException>()));
      },
    );
    test(
      "should call http client with proper arguments and return the response",
      () async {
        // arrange
        when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
            .thenAnswer((_) async => tResponse);
        // act
        sut.setToken(tToken);
        final result = await sut.get(tEndpoint, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.get(
            Uri.https(apiHost, tEndpoint, tBody),
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
    test(
      "should throw NoTokenException if called when token is null",
      () async {
        // assert
        expect(() => sut.post(tEndpoint, tBody),
            throwsA(const TypeMatcher<NoTokenException>()));
      },
    );
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        when(
          () => mockHttpClient.post(
            any(),
            body: any(named: "body"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => tResponse);
        // act
        sut.setToken(tToken);
        final result = await sut.post(tEndpoint, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.post(Uri.https(apiHost, tEndpoint),
              body: tBody, headers: tRightHeaders),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('delete', () {
    final tEndpoint = randomString();
    test(
      "should throw NoTokenException if called when token is null",
      () async {
        // assert
        expect(() => sut.delete(tEndpoint), throwsA(isA<NoTokenException>()));
      },
    );
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        final tResponse = http.Response(randomString(), 4242);
        when(() => mockHttpClient.delete(any(), headers: any(named: "headers")))
            .thenAnswer((_) async => tResponse);
        // act
        sut.setToken(tToken);
        final result = await sut.delete(tEndpoint);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.delete(
            Uri.https(apiHost, tEndpoint),
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
    test(
      "should throw NoTokenException if called when token is null",
      () async {
        // assert
        expect(() => sut.put(tEndpoint, tBody),
            throwsA(const TypeMatcher<NoTokenException>()));
      },
    );
    test(
      "should call http client with proper arguments and return the result",
      () async {
        // arrange
        when(
          () => mockHttpClient.put(
            any(),
            body: any(named: "body"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer((_) async => tResponse);
        // act
        sut.setToken(tToken);
        final result = await sut.put(tEndpoint, tBody);
        // assert
        expect(result, tResponse);
        verify(
          () => mockHttpClient.put(
            Uri.https(apiHost, tEndpoint),
            headers: tRightHeaders,
            body: tBody,
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
  group('sendFiles', () {
    final tAvatarFile = fileFixture('avatar.png');
    const tEndpoint = "update-avatar/42";
    test(
      "should throw NoTokenException if called when token is null",
      () async {
        // act
        expect(() => sut.sendFiles("", "", {}, {}),
            throwsA(isA<NoTokenException>()));
      },
    );
    test(
      "should call http client with proper args and return the result",
      () async {
        // arrange
        final tRightRequest = http.MultipartRequest(
          "PUT",
          Uri.https(apiHost, tEndpoint),
        );
        tRightRequest.files.add(http.MultipartFile.fromBytes(
          "avatar",
          await File(tAvatarFile.path).readAsBytes(),
        ));
        tRightRequest.headers['Accept'] = tRightHeaders['Accept']!;
        tRightRequest.headers['Authorization'] =
            tRightHeaders['Authorization']!;
        tRightRequest.fields['about'] = "New about";
        when(() => mockHttpClient.send(any())).thenAnswer(
            (_) async => http.StreamedResponse(Stream.value([1, 2, 3]), 200));
        // act
        sut.setToken(tToken);
        await sut.sendFiles(
            "PUT", tEndpoint, {'avatar': tAvatarFile}, {'about': 'New about'});
        // assert
        final capturedRequest = verify(() => mockHttpClient.send(captureAny()))
            .captured[0] as http.MultipartRequest;
        expect(capturedRequest.files.length, 1);
        expect(capturedRequest.files.first.length,
            tRightRequest.files.first.length);
        expect(capturedRequest.files.first.field, 'avatar');
        expect(capturedRequest.fields.length, 1);
        expect(capturedRequest.fields['about'], 'New about');
        expect(capturedRequest.url, tRightRequest.url);
        expect(capturedRequest.method, tRightRequest.method);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
}
