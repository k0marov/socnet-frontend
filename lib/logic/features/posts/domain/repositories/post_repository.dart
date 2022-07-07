import 'package:dartz/dartz.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../core/error/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, Post>> toggleLike(Post post);
  Future<Either<Failure, void>> deletePost(Post post);
  Future<Either<Failure, List<Post>>> getProfilePosts(Profile profile);
  Future<Either<Failure, void>> createPost(NewPostValue newPost);
}
