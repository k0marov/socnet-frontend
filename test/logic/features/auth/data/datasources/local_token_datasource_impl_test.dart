import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/auth/data/datasources/local_token_datasource.dart';
import 'package:socnet/logic/features/auth/data/models/token_model.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../../../../shared/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalTokenDataSourceImpl sut;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    sut = LocalTokenDataSourceImpl(mockSharedPreferences);
  });

  group('getToken', () {
    const tTokenModel = TokenModel(Token(token: "424242"));
    test(
      "should get json from shared preferences and return the model",
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(tokenCacheKey))
            .thenAnswer((_) => fixture('auth_response_token.json'));
        // act
        final result = await sut.getToken();
        // assert
        expect(result, tTokenModel);
        verify(() => mockSharedPreferences.getString(tokenCacheKey));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
    test(
      "should throw NoTokenException if nothing is stored in the cache",
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(tokenCacheKey)).thenReturn(null);
        // assert
        expect(() => sut.getToken(), throwsA(const TypeMatcher<NoTokenException>()));
      },
    );
    test(
      "should throw CacheException if shared preferences throws",
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(tokenCacheKey)).thenThrow(Exception());
        // assert
        expect(() => sut.getToken(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
    test(
      "should throw CacheException if some other error happens",
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(tokenCacheKey)).thenReturn("not-a-valid-token-json");
        // assert
        expect(() => sut.getToken(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('storeToken', () {
    const tToken = TokenModel(Token(token: "42"));
    const tJson = {"token": "42"};
    test(
      "should store the token json representation using shared preferences",
      () async {
        // arrange
        when(() => mockSharedPreferences.setString(tokenCacheKey, json.encode(tJson))).thenAnswer((_) async => true);
        // act
        await sut.storeToken(tToken);
        // assert
        verify(() => mockSharedPreferences.setString(tokenCacheKey, json.encode(tJson)));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
    test(
      "should throw CacheException if shared preferences returns false",
      () async {
        // arrange
        when(() => mockSharedPreferences.setString(tokenCacheKey, json.encode(tJson))).thenAnswer((_) async => false);
        // assert
        expect(() => sut.storeToken(tToken), throwsA(const TypeMatcher<CacheException>()));
      },
    );
    test(
      "should throw CacheException is some other error happens",
      () async {
        // arrange
        when(() => mockSharedPreferences.setString(tokenCacheKey, json.encode(tJson))).thenThrow(Exception());
        // assert
        expect(() => sut.storeToken(tToken), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('deleteToken', () {
    test(
      "should remove the token using shared preferences",
      () async {
        // arrange
        when(() => mockSharedPreferences.remove(tokenCacheKey)).thenAnswer((_) async => true);
        // act
        await sut.deleteToken();
        // assert
        verify(() => mockSharedPreferences.remove(tokenCacheKey));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
    test(
      "should throw CacheException if something fails",
      () async {
        // arrange
        when(() => mockSharedPreferences.remove(tokenCacheKey)).thenThrow(Exception());
        // assert
        expect(() => sut.deleteToken(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
    test(
      "should throw CacheException if shared preferences call returns false",
      () async {
        // arrange
        when(() => mockSharedPreferences.remove(tokenCacheKey)).thenAnswer((_) async => false);
        // assert
        expect(() => sut.deleteToken(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });
}
