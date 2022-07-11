import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/auth/data/datasources/local_token_datasource.dart';

import '../../../../../shared/helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("property based test", () async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = RxSharedPreferences.getInstance();
    final sut = LocalTokenDataSourceImpl(sharedPrefs);

    expect(() => sut.getToken(), throwsA(isA<NoTokenException>()));

    final firstToken = randomString();
    await sut.storeToken(firstToken);
    expect(await sut.getToken(), firstToken);

    final secondToken = randomString();
    await sut.storeToken(secondToken);
    expect(await sut.getToken(), secondToken);

    await sut.deleteToken();
    expect(() => sut.getToken(), throwsA(isA<NoTokenException>()));

    // stream test
    final initialToken = randomString();
    await sut.storeToken(initialToken);

    final tokens = [randomString(), randomString(), randomString(), randomString()];

    final wantEvents = ([initialToken] + tokens).map((token) => Right(token));
    expect(sut.getTokenStream(), emitsInOrder(wantEvents));

    for (final token in tokens) {
      await sut.storeToken(token);
    }
  });
}
