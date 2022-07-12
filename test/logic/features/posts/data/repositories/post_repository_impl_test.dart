import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/logic/features/posts/data/models/post_model.dart';
import 'package:socnet/logic/features/posts/data/repositories/post_repository_impl.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
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
      PostModel(tPost),
      (result) => result == null,
      () => mockDataSource,
    );
  });

  group('deletePost', () {
    final tPost = createTestPost();
    final tPostModel = PostModel(tPost);
    baseRepositoryTests(
      () => sut.deletePost(tPost),
      () => mockDataSource.deletePost(tPostModel),
      null,
      (res) => true,
      () => mockDataSource,
    );
  });

  group('getProfilePosts', () {
    final tProfile = createTestProfile();
    final tPosts = [createTestPost(), createTestPost()];
    final tPostsModels = tPosts.map<PostModel>((post) => PostModel(post)).toList();
    baseRepositoryTests(
      () => sut.getProfilePosts(tProfile),
      () => mockDataSource.getProfilePosts(ProfileModel(tProfile)),
      tPostsModels,
      (posts) => listEquals(posts, tPosts),
      () => mockDataSource,
    );
  });

  group('toggleLike', () {
    final tPost = createTestPost();
    final newLikes = tPost.isLiked ? tPost.likes - 1 : tPost.likes + 1;
    final tLikedPost = Post(
      id: tPost.id,
      author: tPost.author,
      createdAt: tPost.createdAt,
      images: tPost.images,
      text: tPost.text,
      likes: newLikes,
      isLiked: !tPost.isLiked,
      isMine: tPost.isMine,
    );
    baseRepositoryTests(
      () => sut.toggleLike(tPost),
      () => mockDataSource.toggleLike(PostModel(tPost)),
      null,
      (result) => result == tLikedPost,
      () => mockDataSource,
    );
  });
}
