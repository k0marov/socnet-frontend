import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/mappers/url_mapper.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import '../../post_helpers.dart';

void main() {
  Post tPost = Post(
    id: "123",
    createdAt: DateTime.parse("1994-11-05T08:15:30-05:00"),
    images: const [apiHost + "/1.png", apiHost + "/2.png", apiHost + "/3.png"],
    text: "Some example text",
    likes: 42,
    isLiked: false,
    author: Profile(
      id: "42",
      username: "some-username",
      avatarUrl:
          URLMapper().shortToLong("/media/user_1/avatar1234blablabla.png"),
      followers: 42,
      follows: 21,
      about: "A Test Profile",
    ),
    isMine: false,
  );
  PostModel tPostModel = PostModel(tPost);

  test(
    "should have a toEntity() method that returns a valid entity",
    () async {
      // assert
      expect(tPostModel.toEntity(), tPost);
    },
  );

  group('fromJson', () {
    test(
      "should convert a json fixture to a valid model",
      () async {
        // arrange
        final tJson = json.decode(fixture('post.json'));
        // act
        final result = PostModel.fromJson(tJson);
        // assert
        expect(result, tPostModel);
      },
    );
  });

  group('toJson', () {
    test(
      "should convert a model to a valid json",
      () async {
        // arrange
        final tExpectedJson = json.decode(fixture('post.json'));
        // act
        final result = tPostModel.toJson();
        // assert
        expect(result, tExpectedJson);
      },
    );
  });

  test(
    "sanity check (chaining the two methods should do nothing)",
    () async {
      // arrange
      final tPost = PostModel(createTestPost());
      // act
      final result = PostModel.fromJson(tPost.toJson());
      // assert
      expect(result, tPost);
    },
  );
}
