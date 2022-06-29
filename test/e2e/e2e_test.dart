import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/di.dart' as di;
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';

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
    );
  });
  tearDown(() async {
    await backend.tearDown();
  });

  test("happy path", () async {
    final result = await usecases.register(RegisterParams(username: "sam", password: "speedx3D"));
    result.fold(
      (failure) => throw Exception(failure),
      (token) => print(token.token),
    );
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
