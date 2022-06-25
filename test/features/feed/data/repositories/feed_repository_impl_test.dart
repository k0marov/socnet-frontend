import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/features/feed/data/mappers/feed_posts_mapper.dart';
import 'package:socnet/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/helpers/base_tests.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../post/post_helpers.dart';

class MockFeedNetworkDataSource extends Mock implements FeedNetworkDataSource {}

void main() {
  late FeedRepositoryImpl sut;
  late MockFeedNetworkDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockFeedNetworkDataSource();
    sut = FeedRepositoryImpl(mockDataSource);
  });

  group('getNextPosts', () {
    final tAmount = randomInt();
    final tPosts = [createTestPost(), createTestPost(), createTestPost()];
    baseRepositoryTests(
      () => sut.getNextPosts(tAmount),
      () => mockDataSource.getNextPosts(tAmount),
      FeedPostsMapper(tPosts),
      (result) => result == tPosts,
      () => mockDataSource,
    );
  });
}
