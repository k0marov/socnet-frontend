import 'dart:convert';

import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/error/helpers.dart';
import 'package:socnet/logic/features/posts/data/mappers/post_mapper.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

abstract class FeedNetworkDataSource {
  /// Throws [NoTokenException] and [NetworkException]
  Future<List<Post>> getNextPosts(int amount);
}

class FeedNetworkDataSourceImpl implements FeedNetworkDataSource {
  final PostMapper _mapper;
  final AuthenticatedAPIFacade _apiFacade;
  FeedNetworkDataSourceImpl(this._mapper, this._apiFacade);

  @override
  Future<List<Post>> getNextPosts(int amount) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(feedEndpoint(amount));
      checkStatusCode(response);
      final postsJson = json.decode(response.body)['posts'] as List;
      return postsJson.map((postJson) => _mapper.fromJson(postJson)).toList();
    });
  }
}
