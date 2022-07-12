import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';

import '../entities/comment.dart';

typedef DeleteCommentUseCase = UseCaseReturn<void> Function(Comment comment);

DeleteCommentUseCase newDeleteCommentUseCase(CommentRepository repo) => (comment) => repo.deleteComment(comment);
