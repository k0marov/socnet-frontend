import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/di.dart' as di;

import 'backend.dart';

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
      apiHost: "locahost:4242",
    );
  });
  tearDown(() async {
    await backend.tearDown();
  });

  test("happy path", () {
    //
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
