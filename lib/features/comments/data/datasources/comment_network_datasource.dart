import 'dart:convert';

import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/error/helpers.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/comments/data/models/comment_model.dart';
import 'package:socnet/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';

abstract class CommentNetworkDataSource {
  /// Throws: [NoTokenException] and [NetworkException]
  Future<CommentModel> addPostComment(
      PostModel post, NewCommentValue newComment);

  /// Throws: [NoTokenException] and [NetworkException]
  Future<void> deleteComment(CommentModel comment);

  /// Throws: [NoTokenException] and [NetworkException]
  Future<void> toggleLikeOnComment(CommentModel comment);

  /// Throws: [NoTokenException] and [NetworkException]
  Future<List<CommentModel>> getPostComments(PostModel post);
}

class CommentNetworkDataSourceImpl implements CommentNetworkDataSource {
  final AuthenticatedAPIFacade _apiFacade;
  CommentNetworkDataSourceImpl(this._apiFacade);

  @override
  Future<CommentModel> addPostComment(
      PostModel post, NewCommentValue newComment) async {
    return exceptionConverterCall(() async {
      final postId = post.toEntity().id;
      final data = {
        'text': newComment.text,
      };
      final response =
          await _apiFacade.post(addPostCommentEndpoint(postId), data);
      checkStatusCode(response);
      return CommentModel.fromJson(json.decode(response.body));
    });
  }

  @override
  Future<void> deleteComment(CommentModel comment) async {
    return exceptionConverterCall(() async {
      final commentId = comment.toEntity().id;
      final response = await _apiFacade.delete(deleteCommentEndpoint(commentId));
      checkStatusCode(response);
    });
  }

  @override
  Future<List<CommentModel>> getPostComments(PostModel post) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(
        getPostCommentsEndpoint(post.toEntity().id),
        {}
      );
      checkStatusCode(response);
      final commentsJson = json.decode(response.body)['comments'] as List;
      return commentsJson.map((json) => CommentModel.fromJson(json)).toList();
    });
  }

  @override
  Future<void> toggleLikeOnComment(CommentModel comment) async {
    return exceptionConverterCall(() async {
      final commentId = comment.toEntity().id;
      final response = await _apiFacade.post(
        toggleLikeOnCommentEndpoint(commentId),
        {},
      );
      checkStatusCode(response);
    });
  }
}
