import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecase.dart';
import 'package:socnet/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/features/posts/domain/values/new_post_value.dart';

class CreatePost extends UseCase<void, PostCreateParams> {
  final PostRepository _repository;
  CreatePost(this._repository);

  @override
  Future<Either<Failure, void>> call(PostCreateParams params) async {
    return _repository.createPost(params.newPost);
  }
}

class PostCreateParams extends Equatable {
  final NewPostValue newPost;
  @override
  List get props => [newPost];
  const PostCreateParams({required this.newPost});
}
