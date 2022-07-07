import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/usecases/comment_params.dart';

class DeleteComment extends UseCase<void, CommentParams> {
  final CommentRepository _repository;

  DeleteComment(this._repository);
  @override
  Future<Either<Failure, void>> call(CommentParams params) async {
    return _repository.deleteComment(params.comment);
  }
}
