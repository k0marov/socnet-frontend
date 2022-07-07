import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/comments/domain/entities/comment.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

class AddComment extends UseCase<Comment, AddCommentParams> {
  final CommentRepository _repository;

  AddComment(this._repository);
  @override
  Future<Either<Failure, Comment>> call(AddCommentParams params) async {
    return _repository.addPostComment(params.post, params.newComment);
  }
}

class AddCommentParams extends Equatable {
  final Post post;
  final NewCommentValue newComment;
  @override
  List get props => [post, newComment];

  const AddCommentParams({
    required this.post,
    required this.newComment,
  });
}
