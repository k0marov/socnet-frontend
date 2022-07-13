import 'dart:convert';

import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/error/helpers.dart';
import 'package:socnet/logic/features/comments/data/mappers/comment_mapper.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';

import '../../../posts/domain/entities/post.dart';
import '../../domain/datasources/comment_network_datasource.dart';
import '../../domain/entities/comment.dart';

class CommentNetworkDataSourceImpl implements CommentNetworkDataSource {
  final CommentMapper _mapper;
  final AuthenticatedAPIFacade _apiFacade;
  CommentNetworkDataSourceImpl(this._mapper, this._apiFacade);

  @override
  Future<Comment> addPostComment(Post post, NewCommentValue newComment) async {
    final data = {
      'text': newComment.text,
    };
    final response = await _apiFacade.post(addPostCommentEndpoint(post.id), data);
    checkStatusCode(response);
    return _mapper.fromJson(json.decode(response.body));
  }

  @override
  Future<void> deleteComment(Comment comment) async {
    final response = await _apiFacade.delete(deleteCommentEndpoint(comment.id));
    checkStatusCode(response);
  }

  @override
  Future<List<Comment>> getPostComments(Post post) async {
    final response = await _apiFacade.get(getPostCommentsEndpoint(post.id));
    checkStatusCode(response);
    final commentsJson = json.decode(response.body)['comments'] as List;
    return commentsJson.map((json) => _mapper.fromJson(json)).toList();
  }

  @override
  Future<void> toggleLikeOnComment(Comment comment) async {
    final response = await _apiFacade.post(
      toggleLikeOnCommentEndpoint(comment.id),
      {},
    );
    checkStatusCode(response);
  }
}
