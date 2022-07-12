import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../core/error/exception_to_failure.dart';
import '../../../profile/data/models/profile_model.dart';

class PostRepositoryImpl implements PostRepository {
  final NetworkPostDataSource _dataSource;
  PostRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> createPost(NewPostValue newPost) async {
    return exceptionToFailureCall(() async {
      await _dataSource.createPost(newPost);
    });
  }

  @override
  Future<Either<Failure, void>> deletePost(Post post) async {
    return exceptionToFailureCall(() async {
      await _dataSource.deletePost(post);
    });
  }

  @override
  Future<Either<Failure, List<Post>>> getProfilePosts(Profile profile) async {
    return exceptionToFailureCall(() async {
      return await _dataSource.getProfilePosts(ProfileModel(profile));
    });
  }

  @override
  Future<Either<Failure, Post>> toggleLike(Post post) async {
    return exceptionToFailureCall(() async {
      await _dataSource.toggleLike(post);
      return post.withLikeToggled();
    });
  }
}
