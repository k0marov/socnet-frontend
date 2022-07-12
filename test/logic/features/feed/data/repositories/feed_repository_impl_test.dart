import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/logic/features/feed/data/repositories/feed_repository_impl.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import '../../../posts/post_helpers.dart';

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
      tPosts,
      (result) => listEquals(result, tPosts),
      () => mockDataSource,
    );
  });
}
