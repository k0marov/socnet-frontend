import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/profile/data/mappers/profile_mapper.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../../shared/fixtures/fixture_reader.dart';

void main() {
  Profile tProfile = Profile(
    id: "42",
    username: "some-username",
    about: "A Test Profile",
    avatarUrl: Some("static.example.com/42/avatar.jpeg"),
    followers: 42,
    follows: 21,
    isMine: true,
    isFollowed: false,
  );

  group('fromJson', () {
    test(
      "should return a profile when valid json is provided",
      () async {
        // arrange
        final tJson = json.decode(fixture('profile.json'));
        // assert
        expect(ProfileMapperImpl().fromJson(tJson), tProfile);
      },
    );
    test("should throw MappingException otherwise", () async {
      expect(() => ProfileMapperImpl().fromJson({"x": "y", "z": "d"}), throwsA(MappingException()));
    });
  });
}
