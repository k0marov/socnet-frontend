import 'package:socnet/core/error/exception_to_failure.dart';
import 'package:socnet/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/features/comments/data/models/comment_model.dart';
import 'package:socnet/features/comments/domain/entities/comment.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';
import 'package:socnet/features/comments/domain/values/new_comment_value.dart';

import '../../../posts/data/models/post_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentNetworkDataSource _dataSource;
  const CommentRepositoryImpl(this._dataSource);
  @override
  Future<Either<Failure, Comment>> addPostComment(
      Post post, NewCommentValue newComment) async {
    return exceptionToFailureCall(() async {
      final result =
          await _dataSource.addPostComment(PostModel(post), newComment);
      return result.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteComment(Comment comment) async {
    return exceptionToFailureCall(() async {
      await _dataSource.deleteComment(CommentModel(comment));
    });
  }

  @override
  Future<Either<Failure, List<Comment>>> getPostComments(Post post) async {
    return exceptionToFailureCall(() async {
      final result = await _dataSource.getPostComments(PostModel(post));
      final comments =
          result.map((commentModel) => commentModel.toEntity()).toList();
      return comments;
    });
  }

  @override
  Future<Either<Failure, Comment>> toggleLikeOnComment(Comment comment) async {
    return exceptionToFailureCall(() async {
      await _dataSource.toggleLikeOnComment(CommentModel(comment));
      final newLikes = comment.isLiked ? comment.likes - 1 : comment.likes + 1;
      final changedComment = Comment(
        id: comment.id,
        author: comment.author,
        createdAt: comment.createdAt,
        text: comment.text,
        likes: newLikes,
        isMine: comment.isMine,
        isLiked: !comment.isLiked,
      );
      return changedComment;
    });
  }
}
