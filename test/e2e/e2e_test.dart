@Tags(["end-to-end"])
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/di.dart' as di;
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';
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

    // logout
    var isSuccessful = await usecases.logout(NoParams());
    expect(isSuccessful.isRight(), true);

    // register another user
    final token2 = forceRight(await usecases.register(RegisterParams(username: "test", password: "pass12345")));
    final profile2 = forceRight(await usecases.getMyProfile(NoParams()));
    expect(profile2.username, "test");

    // follow first user from second user
    isSuccessful = await usecases.toggleFollow(ProfileParams(profile: profile1));
    expect(isSuccessful.isRight(), true);
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
