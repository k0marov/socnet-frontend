import 'dart:convert';

import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/error/helpers.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/posts/data/mappers/post_mapper.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';

import '../../../profile/domain/entities/profile.dart';
import '../../domain/entities/post.dart';

abstract class NetworkPostDataSource {
  /// Throws [NetworkException] and [NoTokenException]
  Future<void> createPost(NewPostValue newPost);

  /// Throws [NetworkException] and [NoTokenException]
  Future<void> deletePost(Post postModel);

  /// Throws [NetworkException] and [NoTokenException]
  Future<List<Post>> getProfilePosts(Profile profileModel);

  /// Throws [NetworkException] and [NoTokenException]
  Future<void> toggleLike(Post postModel);
}

class NetworkPostDataSourceImpl implements NetworkPostDataSource {
  final PostMapper _mapper;
  final AuthenticatedAPIFacade _apiFacade;
  NetworkPostDataSourceImpl(this._mapper, this._apiFacade);

  @override
  Future<void> createPost(NewPostValue newPost) async {
    return exceptionConverterCall(() async {
      final files = <String, SimpleFile>{};
      for (int i = 0; i < newPost.images.length; ++i) {
        files['image_${i + 1}'] = newPost.images[i];
      }
      final data = {
        'text': newPost.text,
      };

      final response = await _apiFacade.sendFiles("POST", createPostEndpoint(), files, data);
      checkStatusCode(response);
    });
  }

  @override
  Future<void> deletePost(Post postModel) async {
    return exceptionConverterCall(() async {
      final postId = postModel.id;

      final response = await _apiFacade.delete(deletePostEndpoint(postId));
      checkStatusCode(response);
    });
  }

  @override
  Future<List<Post>> getProfilePosts(Profile profileModel) async {
    return exceptionConverterCall(() async {
      final profileId = profileModel.id;

      final response = await _apiFacade.get(getProfilePostsEndpoint(profileId));
      checkStatusCode(response);

      final postsJson = json.decode(response.body)["posts"];
      return (postsJson as List).map((postJson) => _mapper.fromJson(postJson)).toList();
    });
  }

  @override
  Future<void> toggleLike(Post postModel) async {
    return exceptionConverterCall(() async {
      final postId = postModel.id;
      final response = await _apiFacade.post(toggleLikeOnPostEndpoint(postId), {});
      checkStatusCode(response);
    });
  }
}
