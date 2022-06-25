import 'package:socnet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/features/comments/domain/usecases/comment_params.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/comment.dart';

class ToggleLikeOnComment extends UseCase<Comment, CommentParams> {
  final CommentRepository _repository;
  ToggleLikeOnComment(this._repository);

  @override
  Future<Either<Failure, Comment>> call(CommentParams params) async {
    return _repository.toggleLikeOnComment(params.comment);
  }
}
