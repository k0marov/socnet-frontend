import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/di.dart' as di;
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';

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
    final token = forceRight(await usecases.register(RegisterParams(username: "sam", password: "speedx3D")));
    // try to login with the same credentials
    final tokenFromLogin = forceRight(await usecases.login(LoginParams(username: "sam", password: "speedx3D")));
    // assert that returned tokens are equal
    expect(tokenFromLogin, token);

    final myProfile = forceRight(await usecases.getMyProfile(NoParams()));
    expect(myProfile.username, "sam");
    expect(myProfile.isMine, true);
    expect(myProfile.isFollowed, false);
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
