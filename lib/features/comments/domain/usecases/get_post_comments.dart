import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecase.dart';
import 'package:socnet/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/features/posts/domain/usecases/post_params.dart';

import '../entities/comment.dart';

class GetPostComments extends UseCase<List<Comment>, PostParams> {
  final CommentRepository _repository;
  GetPostComments(this._repository);
  @override
  Future<Either<Failure, List<Comment>>> call(PostParams params) async {
    return _repository.getPostComments(params.post);
  }
}
