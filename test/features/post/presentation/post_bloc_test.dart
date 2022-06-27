import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';
import 'package:socnet/features/posts/domain/usecases/delete_post.dart';
import 'package:socnet/features/posts/domain/usecases/post_params.dart';
import 'package:socnet/features/posts/domain/usecases/toggle_like.dart';
import 'package:socnet/features/posts/presentation/post_bloc/post_bloc.dart';

import '../../../core/helpers/helpers.dart';
import '../post_helpers.dart';

class MockDeletePost extends Mock implements DeletePost {}

class MockToggleLike extends Mock implements ToggleLike {}

void main() {
  final tPost = createTestPost();
  late PostBloc sut;
  late MockDeletePost mockDeletePost;
  late MockToggleLike mockToggleLike;

  setUp(() {
    mockDeletePost = MockDeletePost();
    mockToggleLike = MockToggleLike();
    final creator = PostBlocCreator(mockDeletePost, mockToggleLike);
    sut = creator.create(tPost);
  });

  test(
    "should have initial state = PostLoaded",
    () async {
      // assert
      expect(sut.state, PostLoaded(tPost));
    },
  );

  group('PostDeletedEvent', () {
    Future<Either<Failure, void>> useCaseCall() => mockDeletePost(PostParams(post: tPost));
    test(
      "should do nothing if state is not PostLoaded",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(PostDeletedState());
          // act
          sut.add(PostDeletedEvent());
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, PostDeletedState());
          verifyZeroInteractions(mockDeletePost);
          verifyZeroInteractions(mockToggleLike);
        });
      },
    );
    test(
      "should call usecase if state is PostLoaded",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => const Right(null));
        // act
        sut.add(PostDeletedEvent());
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractions(mockDeletePost);
        verifyZeroInteractions(mockToggleLike);
      },
    );
    test(
      "should set state to [Deleting, Deleted] if usecase call is successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => const Right(null));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              PostDeleting(tPost),
              PostDeletedState(),
            ]));
        // act
        sut.add(PostDeletedEvent());
      },
    );
    test(
      "should set state to [Deleting, Failure] if usecase call is not successful",
      () async {
        // arrange
        final tFailure = randomFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        // assert later
        expect(sut.stream, emitsInOrder([PostDeleting(tPost), PostFailure(tPost, tFailure)]));
        // act
        sut.add(PostDeletedEvent());
      },
    );
  });
  group('LikeToggled', () {
    final tPostLiked = createTestPost();
    Future<Either<Failure, Post>> useCaseCall() => mockToggleLike(PostParams(post: tPost));
    test(
      "should do nothing if state is not PostLoaded",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(PostDeletedState());
          // act
          sut.add(LikeToggled());
          // assert
          async.elapse(const Duration(seconds: 5));
          verifyZeroInteractions(mockDeletePost);
          verifyZeroInteractions(mockToggleLike);
        });
      },
    );
    test(
      "should call usecase if state is PostLoaded",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tPostLiked));
        // act
        sut.add(LikeToggled());
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractions(mockToggleLike);
        verifyZeroInteractions(mockDeletePost);
      },
    );
    test(
      "should set state to [PostLikeUpdating, Loaded] if usecase call is successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tPostLiked));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              PostLikeUpdating(tPost),
              PostLoaded(tPostLiked),
            ]));
        // act
        sut.add(LikeToggled());
      },
    );
    test(
      "should set state to [PostLikeUpdating, Failure] if usecase call is not successful",
      () async {
        // arrange
        final tFailure = randomFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              PostLikeUpdating(tPost),
              PostFailure(tPost, tFailure),
            ]));
        // act
        sut.add(LikeToggled());
      },
    );
  });
}
