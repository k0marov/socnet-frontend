import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/usecases/comment_params.dart';

import '../../../../core/usecase.dart';
import '../entities/comment.dart';

class ToggleLikeOnComment extends UseCase<Comment, CommentParams> {
  final CommentRepository _repository;
  ToggleLikeOnComment(this._repository);

  @override
  Future<Either<Failure, Comment>> call(CommentParams params) async {
    return _repository.toggleLikeOnComment(params.comment);
  }
}
