import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';

import '../../../posts/domain/entities/post.dart';
import '../../domain/entities/comment.dart';

abstract class CommentNetworkDataSource {
  /// Throws: [NoTokenFailure] and [NetworkFailure]
  Future<Comment> addPostComment(Post post, NewCommentValue newComment);

  /// Throws: [NoTokenFailure] and [NetworkFailure]
  Future<void> deleteComment(Comment comment);

  /// Throws: [NoTokenFailure] and [NetworkFailure]
  Future<void> toggleLikeOnComment(Comment comment);

  /// Throws: [NoTokenFailure] and [NetworkFailure]
  Future<List<Comment>> getPostComments(Post post);
}
