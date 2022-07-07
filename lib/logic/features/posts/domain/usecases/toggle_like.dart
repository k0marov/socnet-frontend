import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/logic/features/posts/domain/usecases/post_params.dart';

class ToggleLike extends UseCase<Post, PostParams> {
  final PostRepository _repository;
  ToggleLike(this._repository);

  @override
  Future<Either<Failure, Post>> call(PostParams params) async {
    return _repository.toggleLike(params.post);
  }
}