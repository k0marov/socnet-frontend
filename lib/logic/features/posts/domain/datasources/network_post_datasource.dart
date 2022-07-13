import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';

import '../../../profile/domain/entities/profile.dart';
import '../../domain/entities/post.dart';

abstract class NetworkPostDataSource {
  /// Throws [NetworkFailure] and [NoTokenFailure]
  Future<void> createPost(NewPostValue newPost);

  /// Throws [NetworkFailure] and [NoTokenFailure]
  Future<void> deletePost(Post postModel);

  /// Throws [NetworkFailure] and [NoTokenFailure]
  Future<List<Post>> getProfilePosts(Profile profileModel);

  /// Throws [NetworkFailure] and [NoTokenFailure]
  Future<void> toggleLike(Post postModel);
}
