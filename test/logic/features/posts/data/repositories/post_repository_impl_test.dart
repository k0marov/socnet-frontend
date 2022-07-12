import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/logic/features/posts/data/repositories/post_repository_impl.dart';
import 'package:socnet/logic/features/profile/data/models/profile_model.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../profile/shared.dart';
import '../../post_helpers.dart';

class MockNetworkPostDataSource extends Mock implements NetworkPostDataSource {}

void main() {
  late PostRepositoryImpl sut;
  late MockNetworkPostDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockNetworkPostDataSource();
    sut = PostRepositoryImpl(mockDataSource);
  });

  group('createPost', () {
    final tNewPost = createTestNewPost();
    final tPost = createTestPost();
    baseRepositoryTests(
      () => sut.createPost(tNewPost),
      () => mockDataSource.createPost(tNewPost),
      tPost,
      (result) => result == null,
      () => mockDataSource,
    );
  });

  group('deletePost', () {
    final tPost = createTestPost();
    baseRepositoryTests(
      () => sut.deletePost(tPost),
      () => mockDataSource.deletePost(tPost),
      null,
      (res) => true,
      () => mockDataSource,
    );
  });

  group('getProfilePosts', () {
    final tProfile = createTestProfile();
    final tPosts = [createTestPost(), createTestPost()];
    baseRepositoryTests(
      () => sut.getProfilePosts(tProfile),
      () => mockDataSource.getProfilePosts(ProfileModel(tProfile)),
      tPosts,
      (posts) => listEquals(posts, tPosts),
      () => mockDataSource,
    );
  });

  group('toggleLike', () {
    final tPost = createTestPost();
    final tLikedPost = tPost.withLikeToggled();
    baseRepositoryTests(
      () => sut.toggleLike(tPost),
      () => mockDataSource.toggleLike(tPost),
      null,
      (result) => result == tLikedPost,
      () => mockDataSource,
    );
  });
}
