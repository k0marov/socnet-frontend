import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/exception_to_failure.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/logic/features/comments/domain/entities/comment.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../posts/data/models/post_model.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentNetworkDataSource _dataSource;
  const CommentRepositoryImpl(this._dataSource);
  @override
  Future<Either<Failure, Comment>> addPostComment(Post post, NewCommentValue newComment) async {
    return exceptionToFailureCall(() async {
      final result = await _dataSource.addPostComment(PostModel(post), newComment);
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> deleteComment(Comment comment) async {
    return exceptionToFailureCall(() async {
      await _dataSource.deleteComment(comment);
    });
  }

  @override
  Future<Either<Failure, List<Comment>>> getPostComments(Post post) async {
    return exceptionToFailureCall(() async {
      final result = await _dataSource.getPostComments(PostModel(post));
      return result.map((commentModel) => commentModel).toList();
    });
  }

  @override
  Future<Either<Failure, Comment>> toggleLikeOnComment(Comment comment) async {
    return exceptionToFailureCall(() async {
      await _dataSource.toggleLikeOnComment(comment);
      return comment.withLikeToggled();
    });
  }
}
