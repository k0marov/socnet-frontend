import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../posts/domain/entities/post.dart';
import '../entities/comment.dart';
import '../values/new_comment_value.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> getPostComments(Post post);
  Future<Either<Failure, Comment>> addPostComment(
      Post post, NewCommentValue newComment);
  Future<Either<Failure, Comment>> toggleLikeOnComment(Comment comment);
  Future<Either<Failure, void>> deleteComment(Comment comment);
}
