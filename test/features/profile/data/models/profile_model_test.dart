import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/api.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  late Profile profile;
  late ProfileModel profileModel;

  setUp(() {
    profile = const Profile(
      id: "42",
      username: "some-username",
      about: "A Test Profile",
      avatarUrl: apiHost + "/media/user_1/avatar1234blablabla.png",
      followers: 42,
      follows: 21,
    );
    profileModel = ProfileModel(profile);
  });

  test(
    "should have a toEntity method that returns the valid entity",
    () async {
      // assert
      expect(profileModel.toEntity(), profile);
    },
  );
  group('fromJson', () {
    test(
      "should convert a json fixture to a valid model",
      () async {
        // arrange
        final tJson = json.decode(fixture('profile.json'));
        // act
        final result = ProfileModel.fromJson(tJson);
        // assert
        expect(result, profileModel);
      },
    );
  });
  group('toJson', () {
    test(
      "should convert a model to a valid json",
      () async {
        // arrange
        final tExpectedJson = json.decode(fixture('profile.json'));
        // act
        final tJson = profileModel.toJson();
        // assert
        expect(tJson, tExpectedJson);
      },
    );
  });
}
