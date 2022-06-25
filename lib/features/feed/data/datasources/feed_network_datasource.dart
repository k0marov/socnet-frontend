import 'dart:convert';

import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/error/helpers.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';

abstract class FeedNetworkDataSource {
  /// Throws [NoTokenException] and [NetworkException]
  Future<List<PostModel>> getNextPosts(int amount);
}

class FeedNetworkDataSourceImpl implements FeedNetworkDataSource {
  final AuthenticatedAPIFacade _apiFacade;
  FeedNetworkDataSourceImpl(this._apiFacade);

  @override
  Future<List<PostModel>> getNextPosts(int amount) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(feedEndpoint(amount), {});
      checkStatusCode(response);
      final postsJson = json.decode(response.body)['posts'] as List;
      return postsJson.map((postJson) => PostModel.fromJson(postJson)).toList();
    });
  }
}
