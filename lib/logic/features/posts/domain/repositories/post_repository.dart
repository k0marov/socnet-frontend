import 'package:dartz/dartz.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/helpers.dart';
import '../datasources/network_post_datasource.dart';

abstract class PostRepository {
  Future<Either<Failure, Post>> toggleLike(Post post);
  Future<Either<Failure, void>> deletePost(Post post);
  Future<Either<Failure, List<Post>>> getProfilePosts(Profile profile);
  Future<Either<Failure, void>> createPost(NewPostValue newPost);
}

class PostRepositoryImpl implements PostRepository {
  final NetworkPostDataSource _dataSource;
  PostRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> createPost(NewPostValue newPost) async {
    return failureToLeft(() => _dataSource.createPost(newPost));
  }

  @override
  Future<Either<Failure, void>> deletePost(Post post) async {
    return failureToLeft(() => _dataSource.deletePost(post));
  }

  @override
  Future<Either<Failure, List<Post>>> getProfilePosts(Profile profile) async {
    return failureToLeft(() => _dataSource.getProfilePosts(profile));
  }

  @override
  Future<Either<Failure, Post>> toggleLike(Post post) async {
    return failureToLeft(() async {
      await _dataSource.toggleLike(post);
      return post.withLikeToggled();
    });
  }
}
