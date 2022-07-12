import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/comments/domain/entities/comment.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/comments/presentation/comments_cubit/comments_cubit.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../../shared/helpers/helpers.dart';
import '../../../posts/post_helpers.dart';
import '../../comment_helpers.dart';

abstract class DeleteComment {
  UseCaseReturn<void> call(Comment _);
}

abstract class AddComment {
  UseCaseReturn<Comment> call(Post _, NewCommentValue __);
}

abstract class ToggleLikeOnComment {
  UseCaseReturn<Comment> call(Comment _);
}

class MockDeleteComment extends Mock implements DeleteComment {}

class MockAddComment extends Mock implements AddComment {}

class MockToggleLikeOnComment extends Mock implements ToggleLikeOnComment {}

void main() {
  late MockDeleteComment mockDeleteComment;
  late MockAddComment mockAddComment;
  late MockToggleLikeOnComment mockToggleLike;
  late CommentsCubit sut;

  final tPost = createTestPost();
  final tComments = [createTestComment(), createTestComment(), createTestComment()];

  setUp(() {
    mockDeleteComment = MockDeleteComment();
    mockAddComment = MockAddComment();
    mockToggleLike = MockToggleLikeOnComment();
    sut = commentsCubitFactoryImpl(mockAddComment, mockDeleteComment, mockToggleLike)(tPost, tComments);
  });

  final tInitial = CommentsState(tComments);
  test(
    "should have initial state with all the comments provided to factory",
    () async {
      // assert
      expect(sut.state, tInitial);
    },
  );

  void verifyNoMoreInteractionsWithUseCases() {
    verifyNoMoreInteractions(mockDeleteComment);
    verifyNoMoreInteractions(mockAddComment);
    verifyNoMoreInteractions(mockToggleLike);
  }

  group('addComment', () {
    final tText = randomString();
    final tNewComment = NewCommentValue(text: tText);
    final tAddedComment = createTestComment();

    Future act() => sut.addComment(tText);
    Future<Either<Failure, Comment>> useCaseCall() => mockAddComment(tPost, tNewComment);

    test(
      "should call usecase, remove failure and add new comment to state if usecase call is successful",
      () async {
        when(useCaseCall).thenAnswer((_) async => Right(tAddedComment));
        await act();
        expect(sut.state, tInitial.withoutFailure().withComments([tAddedComment] + tComments));
        verify(useCaseCall);
        verifyNoMoreInteractionsWithUseCases();
      },
    );
    test("should add failure to state if usecase call is unsuccessful", () async {
      final tFailure = randomFailure();
      when(useCaseCall).thenAnswer((_) async => Left(tFailure));
      await act();
      expect(sut.state, tInitial.withFailure(tFailure));
    });
  });
  group('CommentDeleted', () {
    final deletedComment = tComments[1];

    Future<Either<Failure, void>> useCaseCall() => mockDeleteComment(deletedComment);
    Future act() => sut.deleteComment(deletedComment);
    test(
      "should clear failures and delete comment from state if usecase call is successful",
      () async {
        when(useCaseCall).thenAnswer((_) async => const Right(null));
        await act();
        expect(sut.state, tInitial.withoutFailure().withComments([tComments[0], tComments[2]]));
        verify(useCaseCall);
        verifyNoMoreInteractionsWithUseCases();
      },
    );
    test(
      "should add failure to state if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = randomFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        await act();
        expect(sut.state, tInitial.withFailure(tFailure));
      },
    );
  });

  group('CommentLikePressed', () {
    final tTarget = tComments[2];
    final tLiked = createTestComment();

    Future<Either<Failure, Comment>> useCaseCall() => mockToggleLike(tTarget);
    Future act() => sut.likePressed(tTarget);

    test(
      "should update state to have liked/unliked comment and remove failures if usecase call is successful",
      () async {
        when(useCaseCall).thenAnswer((_) async => Right(tLiked));
        await act();
        expect(sut.state, tInitial.withoutFailure().withComments([tComments[0], tComments[1], tLiked]));
      },
    );
    test(
      "should set state to LoadedFailure if usecase call is unsuccessful",
      () async {
        // arrange
        final tFailure = randomFailure();
        when(useCaseCall).thenAnswer((_) async => Left(tFailure));
        await act();
        expect(sut.state, tInitial.withFailure(tFailure));
      },
    );
  });
}
