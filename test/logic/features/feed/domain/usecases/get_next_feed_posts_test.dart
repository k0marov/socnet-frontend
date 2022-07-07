import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/feed/domain/repositories/feed_repository.dart';
import 'package:socnet/logic/features/feed/domain/usecases/get_next_feed_posts.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';

class MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late GetNextFeedPosts sut;
  late MockFeedRepository mockFeedRepository;

  setUp(() {
    mockFeedRepository = MockFeedRepository();
    sut = GetNextFeedPosts(mockFeedRepository);
  });

  final tAmount = randomInt();
  test(
    "should forward the call to the repository",
    () async {
      baseUseCaseTest(
        () => sut(FeedParams(amount: tAmount)),
        () => mockFeedRepository.getNextPosts(tAmount),
        mockFeedRepository,
      );
    },
  );
}