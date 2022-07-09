import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';

class TestCase {
  final String pass;
  final PassStrength strength;
  const TestCase(this.pass, this.strength);
}

void main() {
  const testCases = [
    TestCase("", PassStrength.none),
    TestCase("abcd", PassStrength.weak),
    TestCase("abcdefgh", PassStrength.normal),
    TestCase("abcdefgh123", PassStrength.strong),
    TestCase("abcdefgh123#", PassStrength.veryStrong),
  ];

  for (final testCase in testCases) {
    test("should return ${testCase.strength} for ${testCase.pass}", () async {
      final got = passStrengthGetterImpl(testCase.pass);
      expect(got, testCase.strength);
    });
  }
}
