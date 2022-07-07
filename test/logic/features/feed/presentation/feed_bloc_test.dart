import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/feed/domain/usecases/get_next_feed_posts.dart';
import 'package:socnet/logic/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../shared/helpers/helpers.dart';
import '../../post/post_helpers.dart';

class MockGetNextFeedPosts extends Mock implements GetNextFeedPosts {}

void main() {
  late FeedBloc sut;
  late MockGetNextFeedPosts mockGetPosts;

  final tAmountOfPostsPerLoad = randomInt();
  setUp(() {
    mockGetPosts = MockGetNextFeedPosts();
    sut = FeedBloc(mockGetPosts, tAmountOfPostsPerLoad);
  });

  test(
    "should have initial state = FeedInitial",
    () async {
      // assert
      expect(sut.state, FeedInitial());
    },
  );

  final tInitialPosts = [
    createTestPost(),
    createTestPost(),
    createTestPost(),
  ];
  final tFetchedPosts = [
    createTestPost(),
    createTestPost(),
  ];
  void emitLoaded() => sut.emit(FeedLoaded(currentPosts: tInitialPosts));
  Future<Either<Failure, List<Post>>> useCaseCall() => mockGetPosts(FeedParams(amount: tAmountOfPostsPerLoad));

  group('ScrolledToBottomEvent', () {
    void act() => sut.add(ScrolledToBottomEvent());
    test(
      "should do nothing if state is Loading",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(const FeedLoading());
          // act
          act();
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, const FeedLoading());
          verifyNoMoreInteractions(mockGetPosts);
        });
      },
    );
    test(
      "should call usecase if state is not Loading",
      () async {
        // arrange
        emitLoaded();
        when(useCaseCall).thenAnswer((_) async => Right(tFetchedPosts));
        // act
        act();
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractions(mockGetPosts);
      },
    );
    test(
      "should set state to [Loading, Loaded] with added posts if usecase call is successful",
      () async {
        // arrange
        emitLoaded();
        when(useCaseCall).thenAnswer((_) async => Right(tFetchedPosts));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              FeedLoading(currentPosts: tInitialPosts),
              FeedLoaded(currentPosts: tInitialPosts + tFetchedPosts),
            ]));
        // act
        act();
      },
    );
    test(
      "should set state to [Loading, Failure] if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = randomFailure();
        emitLoaded();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        // assert later
        expect(
          sut.stream,
          emitsInOrder([
            FeedLoading(currentPosts: tInitialPosts),
            FeedFailure(failure: tFailure, currentPosts: tInitialPosts),
          ]),
        );
        // act
        act();
      },
    );
  });

  group('RefreshedEvent', () {
    void act() => sut.add(RefreshedEvent());
    Future<Either<Failure, List<Post>>> useCaseCall() => mockGetPosts(FeedParams(amount: tAmountOfPostsPerLoad));
    test(
      "should do nothing if state is Loading",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(const FeedLoading());
          // act
          act();
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, const FeedLoading());
          verifyZeroInteractions(mockGetPosts);
        });
      },
    );
    test(
      "should call usecase if state is not Loading",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tFetchedPosts));
        emitLoaded();
        // act
        act();
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractions(mockGetPosts);
      },
    );
    test(
      "should set state to [Loading (without posts), Loaded (with posts)] if usecase call is successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tFetchedPosts));
        emitLoaded();
        // assert later
        expect(
          sut.stream,
          emitsInOrder([
            const FeedLoading(),
            FeedLoaded(currentPosts: tFetchedPosts),
          ]),
        );
        // act
        act();
      },
    );

    test(
      "should set state to [Loading, Failure] if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = randomFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        emitLoaded();
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              const FeedLoading(),
              FeedFailure(failure: tFailure),
            ]));
        // act
        act();
      },
    );
  });
}
