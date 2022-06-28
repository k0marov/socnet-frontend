import 'dart:convert';

import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/helpers.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/core/simple_file/simple_file.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';
import 'package:socnet/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';

abstract class NetworkPostDataSource {
  /// Throws [NetworkException] and [NoTokenException]
  Future<void> createPost(NewPostValue newPost);

  /// Throws [NetworkException] and [NoTokenException]
  Future<void> deletePost(PostModel postModel);

  /// Throws [NetworkException] and [NoTokenException]
  Future<List<PostModel>> getProfilePosts(ProfileModel profileModel);

  /// Throws [NetworkException] and [NoTokenException]
  Future<void> toggleLike(PostModel postModel);
}

class NetworkPostDataSourceImpl implements NetworkPostDataSource {
  final AuthenticatedAPIFacade _apiFacade;
  NetworkPostDataSourceImpl(this._apiFacade);

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
  Future<void> deletePost(PostModel postModel) async {
    return exceptionConverterCall(() async {
      final postId = postModel.toEntity().id;

      final response = await _apiFacade.delete(deletePostEndpoint(postId));
      checkStatusCode(response);
    });
  }

  @override
  Future<List<PostModel>> getProfilePosts(ProfileModel profileModel) async {
    return exceptionConverterCall(() async {
      final profileId = profileModel.toEntity().id;

      final response = await _apiFacade.get(getProfilePostsEndpoint(profileId), {});
      checkStatusCode(response);

      final postsJson = json.decode(response.body)["posts"];
      return (postsJson as List).map((postJson) => PostModel.fromJson(postJson)).toList();
    });
  }

  @override
  Future<void> toggleLike(PostModel postModel) async {
    return exceptionConverterCall(() async {
      final postId = postModel.toEntity().id;
      final response = await _apiFacade.post(toggleLikeOnPostEndpoint(postId), {});
      checkStatusCode(response);
    });
  }
}
