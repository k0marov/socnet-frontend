import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/posts/data/mappers/post_mapper.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../../shared/fixtures/fixture_reader.dart';

void main() {
  Post tPost = Post(
    id: "123",
    createdAt: DateTime.utc(2022, 6, 25, 7, 2, 59),
    images: const [
      PostImage(1, ".../1.png"),
      PostImage(2, ".../2.png"),
      PostImage(3, ".../3.png"),
    ],
    text: "Some example text",
    likes: 42,
    author: Profile(
      id: "42",
      username: "some-username",
      avatarUrl: Some("static.example.com/media/user_1/avatar1234blablabla.png"),
      followers: 42,
      follows: 21,
      about: "A Test Profile",
      isMine: false,
      isFollowed: true,
    ),
    isMine: false,
    isLiked: false,
  );

  group('fromJson', () {
    test(
      "should return a post from a valid json",
      () async {
        // arrange
        final tJson = json.decode(fixture('post.json'));
        // act
        final result = PostMapperImpl().fromJson(tJson);
        // assert
        expect(result, tPost);
      },
    );
    test("should throw MappingException otherwise", () async {
      // assert
      expect(() => PostMapperImpl().fromJson({"x": "y"}), throwsA(MappingFailure()));
    });
  });
}
