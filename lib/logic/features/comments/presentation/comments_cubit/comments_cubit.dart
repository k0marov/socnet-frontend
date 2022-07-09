import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/comments/domain/usecases/comment_params.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/usecases/add_comment.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/toggle_like_on_comment.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final AddComment _addComment;
  final DeleteComment _deleteComment;
  final ToggleLikeOnComment _toggleLikeOnComment;

  final Post _post;

  CommentsCubit(this._addComment, this._deleteComment, this._toggleLikeOnComment, this._post, List<Comment> comments)
      : super(CommentsState(comments));

  Future<void> addComment(String text) async {
    final result = await _addComment(AddCommentParams(post: _post, newComment: NewCommentValue(text: text)));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (addedComment) => emit(state.withoutFailure().withComments([addedComment] + state.comments)),
    );
  }

  Future<void> deleteComment(Comment target) async {
    final result = await _deleteComment(CommentParams(comment: target));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => emit(state.withoutFailure().withComments(state.comments.where((c) => c != target))),
    );
  }

  Future<void> likePressed(Comment target) async {
    final result = await _toggleLikeOnComment(CommentParams(comment: target));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (liked) => emit(state.withoutFailure().withComments(state.comments.map((c) => c == target ? liked : c))),
    );
  }
}

typedef CommentsCubitFactory = CommentsCubit Function(Post, List<Comment>);

CommentsCubitFactory commentsCubitFactoryImpl(
        AddComment addComment, DeleteComment deleteComment, ToggleLikeOnComment toggleLike) =>
    (post, comments) => CommentsCubit(addComment, deleteComment, toggleLike, post, comments);
