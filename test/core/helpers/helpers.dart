import 'dart:math';

import 'package:english_words/english_words.dart' as english_words;
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/simple_file/simple_file.dart';

String randomNoun() => english_words.nouns[Random().nextInt(english_words.nouns.length)];
String randomAdjective() =>
    english_words.adjectives[Random().nextInt(english_words.adjectives.length)];
String randomString() => randomAdjective() + " " + randomNoun();

DateTime randomTime() => DateTime.fromMicrosecondsSinceEpoch(
        (DateTime.now().millisecondsSinceEpoch / 1000000).floor() * 1000000)
    .toUtc(); // accuracy to seconds
int randomInt() => Random().nextInt(100);
bool randomBool() => Random().nextInt(1) > 0.5;

NetworkException randomNetworkException() => NetworkException(
      400 + Random().nextInt(100),
      ClientError(randomString(), randomString()),
    );

Failure randomFailure() => NetworkFailure(randomNetworkException());

SimpleFile createTestFile() => SimpleFile(
      path: randomString(),
      filename: randomString(),
    );
