import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/comments/domain/entities/comment.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

typedef AddCommentUseCase = UseCaseReturn<Comment> Function(Post post, NewCommentValue newComment);

AddCommentUseCase newAddCommentUseCase(CommentRepository repo) =>
    (post, newComment) => repo.addPostComment(post, newComment);
