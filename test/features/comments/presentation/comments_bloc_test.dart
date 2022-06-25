import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/comments/domain/entities/comment.dart';
import 'package:socnet/features/comments/domain/usecases/add_comment.dart';
import 'package:socnet/features/comments/domain/usecases/comment_params.dart';
import 'package:socnet/features/comments/domain/usecases/delete_comment.dart';
import 'package:socnet/features/comments/domain/usecases/get_post_comments.dart';
import 'package:socnet/features/comments/domain/usecases/toggle_like_on_comment.dart';
import 'package:socnet/features/comments/presentation/comments_bloc/comments_bloc.dart';
import 'package:socnet/features/posts/domain/usecases/post_params.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/helpers/helpers.dart';
import '../../post/post_helpers.dart';
import '../comment_helpers.dart';

class MockDeleteComment extends Mock implements DeleteComment {}

class MockAddComment extends Mock implements AddComment {}

class MockGetComments extends Mock implements GetPostComments {}

class MockToggleLikeOnComments extends Mock implements ToggleLikeOnComment {}

void main() {
  late CommentsBloc sut;
  late MockDeleteComment mockDeleteComment;
  late MockAddComment mockAddComment;
  late MockGetComments mockGetComments;
  late MockToggleLikeOnComments mockToggleLike;

  setUp(() {
    mockDeleteComment = MockDeleteComment();
    mockAddComment = MockAddComment();
    mockGetComments = MockGetComments();
    mockToggleLike = MockToggleLikeOnComments();
    sut = CommentsBloc(
        mockAddComment, mockDeleteComment, mockGetComments, mockToggleLike);
  });

  test(
    "should have initial state = CommentsInitial",
    () async {
      // assert
      expect(sut.state, CommentsInitial());
    },
  );

  void verifyNoMoreInteractionsWithUseCases() {
    verifyNoMoreInteractions(mockDeleteComment);
    verifyNoMoreInteractions(mockAddComment);
    verifyNoMoreInteractions(mockGetComments);
    verifyNoMoreInteractions(mockToggleLike);
  }

  final tPost = createTestPost();
  final tComments = [
    createTestComment(),
    createTestComment(),
    createTestComment()
  ];
  void emitLoaded() =>
      sut.emit(CommentsLoaded(post: tPost, comments: tComments));
  group('GetComments', () {
    Future<Either<Failure, List<Comment>>> useCaseCall() =>
        mockGetComments(PostParams(post: tPost));
    void act() => sut.add(GetComments(post: tPost));

    test(
      "should do nothing if state is not CommentsInitial",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(const CommentsLoading());
          // act
          act();
          // assert
          async.elapse(const Duration(seconds: 5));
          verifyNoMoreInteractionsWithUseCases();
        });
      },
    );
    test(
      "should call usecase if state is CommentsInitial",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tComments));
        // act
        act();
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractionsWithUseCases();
      },
    );
    test(
      "should set state to [Loading, Loaded] if usecase call was successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tComments));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              const CommentsLoading(),
              CommentsLoaded(post: tPost, comments: tComments),
            ]));
        // act
        act();
      },
    );
    test(
      "should set state to [Loading, LoadingFailure] if usecase call was unsuccessful",
      () async {
        // arrange
        final tFailure = createTestFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        // assert
        expect(
            sut.stream,
            emitsInOrder([
              const CommentsLoading(),
              CommentsLoadingFailure(failure: tFailure),
            ]));
        // act
        act();
      },
    );
  });

  group('addComment', () {
    final tNewComment = createTestNewComment();
    final tAddedComment = createTestComment();

    void act() => sut.add(CommentAdded(newComment: tNewComment));
    Future<Either<Failure, Comment>> useCaseCall() =>
        mockAddComment(AddCommentParams(post: tPost, newComment: tNewComment));

    test(
      "should do nothing if state is not Loaded",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(const CommentsLoading());
          // act
          act();
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, const CommentsLoading());
          verifyNoMoreInteractionsWithUseCases();
        });
      },
    );
    test(
      "should call usecase if state is Loaded",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tAddedComment));
        emitLoaded();
        // act
        act();
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractionsWithUseCases();
      },
    );
    test(
      "should set state to Loaded with added comment if usecase call is successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tAddedComment));
        emitLoaded();
        // assert later
        expect(
          sut.stream,
          emitsInOrder([
            CommentsLoaded(post: tPost, comments: tComments + [tAddedComment])
          ]),
        );
        // act
        act();
      },
    );
    test(
      "should set state to LoadedFailure if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = createTestFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        emitLoaded();
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              CommentsLoadedFailure(
                  failure: tFailure, post: tPost, comments: tComments),
            ]));
        // act
        act();
      },
    );
  });

  group('CommentDeleted', () {
    final deletedComment = tComments[1];

    Future<Either<Failure, void>> useCaseCall() =>
        mockDeleteComment(CommentParams(comment: deletedComment));
    void act() => sut.add(CommentDeleted(deletedComment: deletedComment));
    test(
      "should do nothing if state is not Loaded",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(const CommentsLoading());
          // act
          act();
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, const CommentsLoading());
          verifyNoMoreInteractionsWithUseCases();
        });
      },
    );
    test(
      "should call usecase if state is Loaded",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => const Right(null));
        emitLoaded();
        // act
        act();
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractionsWithUseCases();
      },
    );
    test(
      "should set state to Loaded with target comment deleted if usecase call is successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => const Right(null));
        emitLoaded();
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              CommentsLoaded(
                post: tPost,
                comments: [tComments[0], tComments[2]],
              )
            ]));
        // act
        act();
      },
    );
    test(
      "should set state to LoadedFailure if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = createTestFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        emitLoaded();
        // assert
        expect(
            sut.stream,
            emitsInOrder([
              CommentsLoadedFailure(
                failure: tFailure,
                post: tPost,
                comments: tComments,
              )
            ]));
        // act
        act();
      },
    );
  });

  group('CommentLikePressed', () {
    final tTargetComment = tComments[2];
    final tLikedComment = createTestComment();

    Future<Either<Failure, Comment>> useCaseCall() =>
        mockToggleLike(CommentParams(comment: tTargetComment));
    void act() => sut.add(CommentLikePressed(targetComment: tTargetComment));
    test(
      "should do nothing if state is not Loaded",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(const CommentsLoading());
          // act
          act();
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, const CommentsLoading());
          verifyNoMoreInteractionsWithUseCases();
        });
      },
    );
    test(
      "should call usecase if state is Loaded",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tLikedComment));
        emitLoaded();
        // act
        act();
        // assert
        await untilCalled(useCaseCall);
        verify(useCaseCall);
        verifyNoMoreInteractionsWithUseCases();
      },
    );
    test(
      "should set state to Loaded with liked/unliked comment if usecase call is successful",
      () async {
        // arrange
        when(useCaseCall).thenAnswer((_) async => Right(tLikedComment));
        emitLoaded();
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              CommentsLoaded(
                  post: tPost,
                  comments: [tComments[0], tComments[1], tLikedComment]),
            ]));
        // act
        act();
      },
    );
    test(
      "should set state to LoadedFailure if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = createTestFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        emitLoaded();
        // assert
        expect(
            sut.stream,
            emitsInOrder([
              CommentsLoadedFailure(
                  failure: tFailure, post: tPost, comments: tComments),
            ]));
        // act
        act();
      },
    );
  });
}
