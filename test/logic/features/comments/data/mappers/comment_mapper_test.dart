import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/comments/data/mappers/comment_mapper.dart';
import 'package:socnet/logic/features/comments/domain/entities/comment.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../../shared/fixtures/fixture_reader.dart';

void main() {
  group('fromJson', () {
    final tComment = Comment(
      id: "123",
      author: Profile(
        id: "42",
        username: "some-username",
        avatarUrl: Some("static.example.com/media/user_1/avatar1234blablabla.png"),
        followers: 42,
        follows: 21,
        about: "A Test Profile",
        isMine: false,
        isFollowed: false,
      ),
      text: "Some comment",
      likes: 42,
      isMine: false,
      isLiked: true,
      createdAt: DateTime.utc(2022, 6, 25, 7, 2, 59),
    );
    final tJson = json.decode(fixture('comment.json'));

    test(
      "should return comment if provided json is valid",
      () async {
        // act
        final result = CommentMapperImpl().fromJson(tJson);
        // assert
        expect(result, tComment);
      },
    );
    test("should throw MappingException otherwise", () async {
      // assert
      expect(() => CommentMapperImpl().fromJson({"asdf": "jsdlkaf"}), throwsA(MappingFailure()));
    });
  });
}
