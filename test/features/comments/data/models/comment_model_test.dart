import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/api.dart';
import 'package:socnet/features/comments/data/models/comment_model.dart';
import 'package:socnet/features/comments/domain/entities/comment.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  late CommentModel tCommentModel;
  final tComment = Comment(
    id: "123",
    author: const Profile(
      id: "42",
      username: "some-username",
      avatarUrl: apiHost + "/media/user_1/avatar1234blablabla.png",
      followers: 42,
      follows: 21,
      about: "A Test Profile",
    ),
    text: "Some comment",
    likes: 42,
    isMine: false,
    isLiked: true,
    createdAt: DateTime.utc(1994, 11, 05, 13, 15, 30),
  );

  setUp(() {
    tCommentModel = CommentModel(tComment);
  });

  test(
    "should have a toEntity method that returns a valid entity",
    () async {
      // assert
      expect(tCommentModel.toEntity(), tComment);
    },
  );

  final tJson = json.decode(fixture('comment.json'));

  group('fromJson', () {
    test(
      "should convert json fixture to a valid model",
      () async {
        // act
        final result = CommentModel.fromJson(tJson);
        // assert
        expect(result, tCommentModel);
      },
    );
  });

  group('toJson', () {
    test(
      "should convert a model to a valid json",
      () async {
        // act
        final result = tCommentModel.toJson();
        // assert
        expect(result, tJson);
      },
    );
  });
}
