@Tags(["end-to-end"])
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
    // register a user
    final token1 = forceRight(await usecases.register(RegisterParams(username: "sam", password: "speedx3D")));
    // try to login with the same credentials
    final token1FromLogin = forceRight(await usecases.login(LoginParams(username: "sam", password: "speedx3D")));
    // assert that returned tokens are equal
    expect(token1FromLogin, token1);

    // get my profile
    final profile1 = forceRight(await usecases.getMyProfile(NoParams()));
    expect(profile1.username, "sam");
    expect(profile1.isMine, true);
    expect(profile1.isFollowed, false);
    expect(profile1.follows, 0);
    expect(profile1.followers, 0);

    // logout
    var isSuccessful = await usecases.logout(NoParams());
    expect(isSuccessful.isRight(), true);

    // register another user
    final token2 = forceRight(await usecases.register(RegisterParams(username: "test", password: "pass12345")));
    final profile2 = forceRight(await usecases.getMyProfile(NoParams()));
    expect(profile2.username, "test");

    // get first profile, viewing it from second user
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

    // follow first user from second user
    isSuccessful = await usecases.toggleFollow(ProfileParams(profile: gotProfile1));
    expect(isSuccessful.isRight(), true);

    // assert it was followed
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
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
