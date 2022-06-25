import 'dart:math';

import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/simple_file/simple_file.dart';
import 'package:english_words/english_words.dart' as english_words;

String randomNoun() =>
    english_words.nouns[Random().nextInt(english_words.nouns.length)];
String randomAdjective() =>
    english_words.adjectives[Random().nextInt(english_words.adjectives.length)];
String randomString() => randomAdjective() + " " + randomNoun();

DateTime randomTime() => DateTime.fromMicrosecondsSinceEpoch((DateTime.now().millisecondsSinceEpoch/1000000).floor() * 1000000).toUtc(); // accuracy to seconds
int randomInt() => Random().nextInt(100);
bool randomBool() => Random().nextInt(1) > 0.5;

Failure createTestFailure() => NetworkFailure(
      Random().nextInt(100) + 100,
      randomString(),
    );


SimpleFile createTestFile() => SimpleFile(
      path: randomString(),
      filename: randomString(),
    );
