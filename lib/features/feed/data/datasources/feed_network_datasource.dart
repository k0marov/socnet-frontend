import 'dart:convert';

import 'package:socnet/core/error/helpers.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/feed/data/mappers/feed_posts_mapper.dart';

abstract class FeedNetworkDataSource {
  /// Throws [NoTokenException] and [NetworkException]
  Future<FeedPostsMapper> getNextPosts(int amount);
}

class FeedNetworkDataSourceImpl implements FeedNetworkDataSource {
  final AuthenticatedAPIFacade _apiFacade;
  FeedNetworkDataSourceImpl(this._apiFacade);

  @override
  Future<FeedPostsMapper> getNextPosts(int amount) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get("feed/", {'amount': amount});
      checkStatusCode(response);
      final postsJson = json.decode(response.body);
      return FeedPostsMapper.fromJson(postsJson);
    });
  }
}
