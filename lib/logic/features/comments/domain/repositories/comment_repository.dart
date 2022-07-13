import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/helpers.dart';
import '../../../posts/domain/entities/post.dart';
import '../datasources/comment_network_datasource.dart';
import '../entities/comment.dart';
import '../values/new_comment_value.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> getPostComments(Post post);
  Future<Either<Failure, Comment>> addPostComment(Post post, NewCommentValue newComment);
  Future<Either<Failure, Comment>> toggleLikeOnComment(Comment comment);
  Future<Either<Failure, void>> deleteComment(Comment comment);
}

class CommentRepositoryImpl implements CommentRepository {
  final CommentNetworkDataSource _dataSource;
  const CommentRepositoryImpl(this._dataSource);
  @override
  Future<Either<Failure, Comment>> addPostComment(Post post, NewCommentValue newComment) async {
    return failureToLeft(() => _dataSource.addPostComment(post, newComment));
  }

  @override
  Future<Either<Failure, void>> deleteComment(Comment comment) async {
    return failureToLeft(() => _dataSource.deleteComment(comment));
  }

  @override
  Future<Either<Failure, List<Comment>>> getPostComments(Post post) async {
    return failureToLeft(() => _dataSource.getPostComments(post));
  }

  @override
  Future<Either<Failure, Comment>> toggleLikeOnComment(Comment comment) async {
    return failureToLeft(() async {
      await _dataSource.toggleLikeOnComment(comment);
      return comment.withLikeToggled();
    });
  }
}
