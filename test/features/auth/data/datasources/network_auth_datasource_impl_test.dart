import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/const/endpoints.dart' as endpoints;
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/features/auth/data/models/token_model.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import '../../../../core/helpers/helpers.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NetworkAuthDataSourceImpl sut;

  setUp(() {
    mockHttpClient = MockHttpClient();
    sut = NetworkAuthDataSourceImpl(mockHttpClient);
    registerFallbackValue(Uri());
  });

  const tUsername = "username";
  const tPassword = "password";

  final tTokenResponse = fixture('auth_response_token.json');
  const tToken = TokenModel(Token(token: "424242"));

  void sharedForLoginAndRegister({required bool isLogin}) {
    test(
      "should call api and return the token model if everything was successful",
      () async {
        // arrange
        when(() => mockHttpClient.post(any(),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((_) async => http.Response(tTokenResponse, 200));
        // act
        final result = isLogin
            ? await sut.login(tUsername, tPassword)
            : await sut.register(tUsername, tPassword);
        // assert
        expect(result, tToken);
        final endpoint = isLogin ? endpoints.loginEndpoint() : endpoints.registerEndpoint();
        verify(() => mockHttpClient.post(Uri.https(endpoints.apiHost, endpoint), body: {
              'username': tUsername,
              'password': tPassword,
            }, headers: {
              'Accept': 'application/json'
            }));
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
        expect(() => sut.login(tUsername, tPassword), throwsA(equals(expectedException)));
      },
    );
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
        expect(
            () => sut.login(tUsername, tPassword), throwsA(const TypeMatcher<NetworkException>()));
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
