import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/const/endpoints.dart' as endpoints;
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/data/mappers/token_mapper.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../../../../shared/helpers/helpers.dart';

class MockTokenMapper extends Mock implements TokenMapper {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockTokenMapper mockTokenMapper;
  late MockHttpClient mockHttpClient;
  late NetworkAuthDataSourceImpl sut;

  const tApiHost = "example.com";

  setUp(() {
    mockTokenMapper = MockTokenMapper();
    mockHttpClient = MockHttpClient();
    sut = NetworkAuthDataSourceImpl(mockTokenMapper, mockHttpClient, tApiHost);
    registerFallbackValue(Uri());
  });

  const tUsername = "username";
  const tPassword = "password";

  const tToken = Token(token: "asdf");
  const tTokenJson = {"xyz": "dyx", "adfas": "sdkfjlas"};

  void sharedForLoginAndRegister({required bool isLogin}) {
    final endpoint = isLogin ? endpoints.loginEndpoint() : endpoints.registerEndpoint();
    Future<Token> act() => isLogin ? sut.login(tUsername, tPassword) : sut.register(tUsername, tPassword);
    test(
      "should call api and return the token model if everything was successful",
      () async {
        // arrange
        when(() => mockHttpClient.post(any(), headers: any(named: "headers"), body: any(named: "body")))
            .thenAnswer((_) async => http.Response(json.encode(tTokenJson), 200));
        when(() => mockTokenMapper.fromJson(tTokenJson)).thenReturn(tToken);
        // act
        final result = await act();
        // assert
        expect(result, tToken);
        final wantBody = {
          'username': tUsername,
          'password': tPassword,
        };
        verify(() => mockHttpClient.post(
              endpoint.toURL(tApiHost, true),
              body: json.encode(wantBody),
              headers: {'Accept': 'application/json'},
            ));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
    test(
      "should throw NetworkException if api returned status code != 200",
      () async {
        // arrange
        const tStatusCode = 403;
        final tClientError = ClientError(randomString(), randomString());
        when(() => mockHttpClient.post(
              any(),
              headers: any(named: "headers"),
              body: any(named: "body"),
            )).thenAnswer((_) async => http.Response(
              json.encode(tClientError.toJson()),
              tStatusCode,
            ));
        // assert
        final expectedException = NetworkException(tStatusCode, tClientError);
        expect(act, throwsA(equals(expectedException)));
      },
    );
    test("should rethrow MappingException", () async {
      // arrange
      when(() => mockHttpClient.post(any(), headers: any(named: "headers"), body: any(named: "body")))
          .thenAnswer((_) async => http.Response(json.encode(tTokenJson), 200));
      when(() => mockTokenMapper.fromJson(any())).thenThrow(MappingException());
      // assert
      expect(act, throwsA(isA<MappingException>()));
    });
    test(
      "should throw NetworkException if some other error happened",
      () async {
        // arrange
        when(() => mockHttpClient.post(
              any(),
              body: any(named: "body"),
              headers: any(named: "headers"),
            )).thenThrow(Exception());
        // assert
        expect(act, throwsA(const TypeMatcher<NetworkException>()));
      },
    );
  }

  group('login', () {
    sharedForLoginAndRegister(isLogin: true);
  });
  group('register', () {
    sharedForLoginAndRegister(isLogin: false);
  });
}
