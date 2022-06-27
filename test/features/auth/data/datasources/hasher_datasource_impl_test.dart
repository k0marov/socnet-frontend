import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/features/auth/data/datasources/hasher_datasource.dart';

import '../../../../core/helpers/helpers.dart';

void main() {
  group("hash", () {
    final tSalt = randomString();
    final tPass = randomString();
    final tHash = randomString();
    test("happy case", () async {
      // arrange
      final sut = HasherDataSourceImpl(
        () async => tSalt,
        ({required String password, required String salt}) async =>
            password == tPass && salt == tSalt ? tHash : throw Exception(),
      );
      // act
      final result = await sut.hash(tPass);
      // assert
      expect(result, tHash);
    });
    test("salter throws", () async {
      // arrange
      final sut = HasherDataSourceImpl(
        () => throw Exception(),
        ({required String password, required String salt}) => throw Exception(),
      );
      // assert
      expect(() => sut.hash(tPass), throwsA(HashingException()));
    });
    test("hasher throws", () async {
      // arrange
      final sut = HasherDataSourceImpl(
        () async => tSalt,
        ({required String password, required String salt}) => throw Exception(),
      );
      // assert
      expect(() => sut.hash(tPass), throwsA(HashingException()));
    });
  });
}
