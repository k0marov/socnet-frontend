@Tags(["end-to-end"])

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/di.dart' as di;
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/usecases/get_profile.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';
import 'package:socnet/features/profile/domain/usecases/update_avatar.dart';
import 'package:socnet/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../core/fixtures/fixture_reader.dart';
import '../core/helpers/helpers.dart';
import 'backend.dart';

const apiHost = "localhost:4242";

void main() {
  late Backend backend;
  late di.UseCases usecases;
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });
  setUp(() async {
    backend = Backend();
    await backend.setUp();
    usecases = di.UseCases(
      sharedPrefs: await _getSharedPrefs(),
      httpClient: http.Client(),
      apiHost: apiHost,
      useHTTPS: false,
    );
  });
  tearDown(() async {
    await backend.tearDown();
  });

  test("happy path", () async {
    print("register a user");
    forceRight(await usecases.register(RegisterParams(username: "sam", password: "speedx3D")));
    print("try to login with the same credentials");
    forceRight(await usecases.login(LoginParams(username: "sam", password: "speedx3D")));

    print("get my profile");
    final profile1 = forceRight(await usecases.getMyProfile(NoParams()));
    expect(profile1.username, "sam");
    expect(profile1.isMine, true);
    expect(profile1.isFollowed, false);
    expect(profile1.follows, 0);
    expect(profile1.followers, 0);

    print("logout");
    forceRight(await usecases.logout(NoParams()));

    print("register another user");
    forceRight(await usecases.register(RegisterParams(username: "test", password: "pass12345")));
    final profile2 = forceRight(await usecases.getMyProfile(NoParams()));
    expect(profile2.username, "test");

    print("get first profile, viewing from second user");
    final gotProfile1 = forceRight(await usecases.getProfile(ProfileIDParams(profile1.id)));
    final wantProfile1 = Profile(
      id: profile1.id,
      username: profile1.username,
      about: profile1.about,
      avatarUrl: profile1.avatarUrl,
      followers: profile1.followers,
      follows: profile1.follows,
      isMine: false, // important part
      isFollowed: profile1.isFollowed,
    );
    expect(gotProfile1, wantProfile1);

    print("follow first user from second user");
    forceRight(await usecases.toggleFollow(ProfileParams(profile: gotProfile1)));

    print("assert it was followed");
    final wantProfile1Followed = Profile(
      id: profile1.id,
      username: profile1.username,
      about: profile1.about,
      avatarUrl: profile1.avatarUrl,
      follows: profile1.follows,
      followers: 1,
      isMine: false,
      isFollowed: true,
    );
    final gotProfile1Followed = forceRight(await usecases.getProfile(ProfileIDParams(profile1.id)));
    expect(gotProfile1Followed, wantProfile1Followed);

    final gotProfile2AfterFollowing = forceRight(await usecases.getMyProfile(NoParams()));
    expect(gotProfile2AfterFollowing.follows, 1);

    print("get follows of second profile");
    final profile2Follows = forceRight(await usecases.getFollows(ProfileParams(profile: gotProfile2AfterFollowing)));
    expect(profile2Follows.length, 1);
    expect(profile2Follows[0], wantProfile1Followed);

    print("update about");
    final updatedProfile2 = forceRight(await usecases.updateProfile(
      const ProfileUpdateParams(
        newInfo: ProfileUpdate(newAbout: "New About"),
      ),
    ));
    expect(updatedProfile2.about, "New About");

    print("update avatar");
    final newAvatar = fileFixture("avatar.png");
    final newURL = forceRight(await usecases.updateAvatar(AvatarParams(newAvatar: newAvatar)));
    final avatarFromStatic = backend.getStaticFile(newURL);
    expect(avatarFromStatic.readAsBytesSync(), File(newAvatar.path).readAsBytesSync());
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
