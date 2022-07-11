import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/feed/domain/usecases/get_next_feed_posts.dart';
import 'package:socnet/logic/features/feed/presentation/feed_cubit/feed_cubit.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../../shared/helpers/helpers.dart';
import '../../../post/post_helpers.dart';

class MockGetNextFeedPosts extends Mock implements GetNextFeedPosts {}

void main() {
  late FeedCubit sut;
  late MockGetNextFeedPosts mockGetPosts;

  final tLoadAmount = randomInt();
  setUp(() {
    mockGetPosts = MockGetNextFeedPosts();
    sut = feedCubitFactoryImpl(mockGetPosts)(tLoadAmount);
  });

  const initialState = FeedState([], false, null);

  test(
    "should have initial state with no posts and failures and isLoading = false",
    () async {
      expect(sut.state, initialState);
    },
  );

  final tPosts = [
    createTestPost(),
    createTestPost(),
    createTestPost(),
  ];
  final filledState = initialState.withPosts(tPosts).withFailure(randomFailure());

  group('scrolledToBottom()', () {
    Future<Either<Failure, List<Post>>> useCaseCall() => mockGetPosts(FeedParams(amount: tLoadAmount));
    Future<void> setUpUseCaseAndAct(Either<Failure, List<Post>> result) async {
      when(useCaseCall).thenAnswer((_) async => result);
      await sut.scrolledToBottom();
    }

    test(
      "should do nothing if already is loading",
      () async {
        final loadingState = filledState.withIsLoading(true);
        sut.emit(loadingState);
        when(useCaseCall).thenThrow(Exception());
        await sut.scrolledToBottom();
        expect(sut.state, loadingState);
      },
    );
    test(
      "should set state to [Loading, Loaded with added posts] if usecase call is successful",
      () async {
        final tFetchedPosts = [
          createTestPost(),
          createTestPost(),
        ];
        sut.emit(filledState);
        expect(
            sut.stream,
            emitsInOrder([
              filledState.withIsLoading(true),
              filledState.withoutFailure().withPosts(tPosts + tFetchedPosts),
            ]));
        setUpUseCaseAndAct(Right(tFetchedPosts));
      },
    );
    test(
      "should set state to [Loading, Failure] if usecase call is unsuccessful",
      () async {
        sut.emit(filledState);
        final tFailure = randomFailure();
        expect(
          sut.stream,
          emitsInOrder([
            filledState.withIsLoading(true),
            filledState.withFailure(tFailure),
          ]),
        );
        setUpUseCaseAndAct(Left(tFailure));
      },
    );
  });

  group('RefreshedEvent', () {
    test(
      "should do nothing if state is Loading",
      () async {
        final loadingState = filledState.withIsLoading(true);
        sut.emit(loadingState);
        sut.refreshed();
        expect(sut.state, loadingState);
      },
    );
    test(
      "should set state back to initial",
      () async {
        sut.emit(filledState);
        sut.refreshed();
        expect(sut.state, initialState);
      },
    );
  });
}
