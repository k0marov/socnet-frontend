import 'package:socnet/core/const/endpoints.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/mappers/url_mapper.dart';

import '../helpers/helpers.dart';

void main() {
  setUp(() {});

  group('shortToLong', () {
    test(
      "should return api host + short url",
      () async {
        // arrange
        final short = '/' + randomString();
        // act
        final result = URLMapper().shortToLong(short);
        // assert
        expect(result, apiHost + short);
      },
    );
  });
  group('longToShort', () {
    test(
      "should return url with stripped host",
      () async {
        // arrange
        final short = '/' + randomString();
        final long = apiHost + short;
        // act
        final result = URLMapper().longToShort(long);
        // assert
        expect(result, short);
      },
    );
  });

  test(
    "sanity check (chaining the two methods should do nothing)",
    () async {
      // assert
      final tUrl = randomString();
      expect(
        URLMapper().longToShort(URLMapper().shortToLong(tUrl)),
        tUrl,
      );
    },
  );
}
