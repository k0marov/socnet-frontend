import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/auth/data/mappers/token_mapper.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';

import '../../../../../shared/fixtures/fixture_reader.dart';

void main() {
  final tFixtureJson = json.decode(fixture("auth_response_token.json"));
  const tFixtureToken = Token(token: "424242");
  group('fromJson', () {
    test(
      "should return a token if input is valid",
      () async {
        // act
        final tModel = TokenMapperImpl().fromJson(tFixtureJson);
        // assert
        expect(tModel, tFixtureToken);
      },
    );
    test("should throw MappingException otherwise", () async {
      // assert
      expect(() => TokenMapperImpl().fromJson({}), throwsA(MappingFailure()));
    });
  });
}
