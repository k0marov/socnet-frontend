import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/features/profile/data/models/my_profile_model.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/entities/my_profile.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  late MyProfile myProfile;
  late MyProfileModel myProfileModel;

  const tProfile = Profile(
    id: "42",
    username: "some-username",
    about: "A Test Profile",
    avatarUrl: apiHost + "/media/user_1/avatar1234blablabla.png",
    followers: 42,
    follows: 21,
  );
  setUp(() {
    myProfile = const MyProfile(
      profile: tProfile,
      follows: [tProfile, tProfile],
    );
    myProfileModel = MyProfileModel(myProfile);
  });

  test(
    "should have a toEntity method that returns a valid entity",
    () async {
      // assert
      expect(myProfileModel.toEntity(), myProfile);
    },
  );
  group('fromJson', () {
    test(
      "should convert a json fixture to a valid model",
      () async {
        // arrange
        final tJson = json.decode(fixture('profile.json'));
        tJson['followsProfiles'] = [
          const ProfileModel(tProfile).toJson(),
          const ProfileModel(tProfile).toJson(),
        ];
        // act
        final result = MyProfileModel.fromJson(tJson);
        // assert
        expect(result, myProfileModel);
      },
    );
  });

  group('toJson', () {
    test(
      "should a model to a valid json",
      () async {
        // arrange
        final tExpectedJson = json.decode(fixture('profile.json'));
        tExpectedJson['followsProfiles'] = [
          const ProfileModel(tProfile).toJson(),
          const ProfileModel(tProfile).toJson(),
        ];
        // act
        final resultJson = myProfileModel.toJson();
        // assert
        expect(resultJson, tExpectedJson);
      },
    );
  });
}
