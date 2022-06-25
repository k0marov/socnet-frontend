import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/features/feed/data/mappers/feed_posts_mapper.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tFixturePosts = [
    Post(
      id: "123",
      author: const Profile(
        id: "42",
        username: "some-username",
        about: "A Test Profile",
        avatarUrl: "static.example.com/media/user_1/avatar1234blablabla.png",
        followers: 42,
        follows: 21,
        isMine: true,
        isFollowed: false,
      ),
      isMine: false,
      createdAt: DateTime.utc(1994, 11, 05, 13, 15, 30),
      images: const [
        apiHost + '/1.png',
        apiHost + '/2.png',
        apiHost + '/3.png',
      ],
      text: "Some example text",
      likes: 42,
      isLiked: false,
    ),
    Post(
      id: "4321",
      author: const Profile(
        id: "33",
        username: "some-other-username",
        about: "Another Test Profile",
        avatarUrl: "static.example.com/media/user_2/avatar1234blablabla.png",
        followers: 33,
        follows: 45,
        isMine: false,
        isFollowed: true,
      ),
      isMine: false,
      createdAt: DateTime.utc(1998, 11, 05, 13, 15, 30),
      images: const [
        apiHost + '/2.png',
        apiHost + '/3.png',
      ],
      text: "Some 2-nd example text",
      likes: 42,
      isLiked: true,
    ),
    Post(
      id: "11",
      author: const Profile(
        id: "555",
        username: "some-third-username",
        about: "A Third Test Profile",
        avatarUrl: null,
        followers: 0,
        follows: 56,
        isMine: false,
        isFollowed: false,
      ),
      isMine: true,
      createdAt: DateTime.utc(2006, 08, 02, 2, 30),
      images: const [],
      text: "Some 3-rd example text",
      likes: 42,
      isLiked: false,
    ),
  ];
  final tFixtureJson = json.decode(fixture('feed_posts.json'));

  final mapper = FeedPostsMapper(tFixturePosts);

  test(
    "should have a toPosts method that returns a valid entity",
    () async {
      // assert
      expect(mapper.toPosts(), tFixturePosts);
    },
  );
  group('toJson', () {
    test(
      "should map posts to valid json",
      () async {
        // assert
        expect(mapper.toJson(), tFixtureJson);
      },
    );
  });
  group('fromJson', () {
    test(
      "should map a json fixture to valid posts list",
      () async {
        // assert
        expect(FeedPostsMapper.fromJson(tFixtureJson), mapper);
      },
    );
  });
}
