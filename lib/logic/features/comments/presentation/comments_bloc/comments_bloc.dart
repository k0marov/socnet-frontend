import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/comments/domain/usecases/add_comment.dart';
import 'package:socnet/logic/features/comments/domain/usecases/comment_params.dart';
import 'package:socnet/logic/features/comments/domain/usecases/delete_comment.dart';
import 'package:socnet/logic/features/comments/domain/usecases/get_post_comments.dart';
import 'package:socnet/logic/features/comments/domain/usecases/toggle_like_on_comment.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/usecases/post_params.dart';

import '../../domain/entities/comment.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final AddComment _addComment;
  final DeleteComment _deleteComment;
  final GetPostComments _getPostComments;
  final ToggleLikeOnComment _toggleLikeOnComment;

  CommentsBloc(
    this._addComment,
    this._deleteComment,
    this._getPostComments,
    this._toggleLikeOnComment,
  ) : super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) async {
      final currentState = state;
      if (event is GetComments) {
        if (currentState is! CommentsInitial) return;
        emit(const CommentsLoading());
        final resultEither = await _getPostComments(PostParams(post: event.post));
        resultEither.fold(
          (failure) => emit(CommentsLoadingFailure(failure: failure)),
          (comments) => emit(CommentsLoaded(post: event.post, comments: comments)),
        );
      } else if (event is CommentAdded) {
        if (currentState is! CommentsLoaded) return;
        final resultEither = await _addComment(AddCommentParams(post: currentState.post, newComment: event.newComment));
        resultEither.fold(
          (failure) => emit(CommentsLoadedFailure(
            failure: failure,
            post: currentState.post,
            comments: currentState.comments,
          )),
          (addedComment) => emit(CommentsLoaded(
            post: currentState.post,
            comments: currentState.comments + [addedComment],
          )),
        );
      } else if (event is CommentDeleted) {
        if (currentState is! CommentsLoaded) return;
        final resultEither = await _deleteComment(CommentParams(comment: event.deletedComment));
        resultEither.fold(
          (failure) => emit(CommentsLoadedFailure(
            failure: failure,
            post: currentState.post,
            comments: currentState.comments,
          )),
          (success) {
            final newComments = currentState.comments.where((comment) => comment != event.deletedComment).toList();
            emit(CommentsLoaded(
              post: currentState.post,
              comments: newComments,
            ));
          },
        );
      } else if (event is CommentLikePressed) {
        if (currentState is! CommentsLoaded) return;
        final resultEither = await _toggleLikeOnComment(CommentParams(comment: event.targetComment));
        resultEither.fold(
          (failure) => emit(CommentsLoadedFailure(
            failure: failure,
            post: currentState.post,
            comments: currentState.comments,
          )),
          (likedComment) {
            final newComments = currentState.comments
                .map<Comment>((comment) => comment == event.targetComment ? likedComment : comment)
                .toList();
            emit(CommentsLoaded(
              post: currentState.post,
              comments: newComments,
            ));
          },
        );
      }
    });
  }
}
