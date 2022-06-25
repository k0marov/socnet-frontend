import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/auth/data/models/token_model.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const tToken = Token(token: "42");

  group('toEntity', () {
    test(
      "should have a toEntity method that returns the right entity",
      () async {
        // arrange
        const tModel = TokenModel(tToken);
        // act
        final result = tModel.toEntity();
        // assert
        expect(result, tToken);
      },
    );
  });

  final tFixtureJson = json.decode(fixture("auth_response_token.json"));
  const tFixtureModel = TokenModel(Token(token: "424242"));
  group('fromJson', () {
    test(
      "should return a valid model",
      () async {
        // act
        final tModel = TokenModel.fromJson(tFixtureJson);
        // assert
        expect(tModel, tFixtureModel);
      },
    );
  });

  group('toJson', () {
    test(
      "should convert to proper json",
      () async {
        // act
        final tJson = tFixtureModel.toJson();
        // assert
        expect(mapEquals(tJson, tFixtureJson), true);
      },
    );
  });
}
