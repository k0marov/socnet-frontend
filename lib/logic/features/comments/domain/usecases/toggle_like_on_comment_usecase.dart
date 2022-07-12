import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';

import '../../../../core/usecase.dart';
import '../entities/comment.dart';

typedef ToggleLikeOnCommentUseCase = UseCaseReturn<Comment> Function(Comment comment);

ToggleLikeOnCommentUseCase newToggleLikeOnCommentUseCase(CommentRepository repo) =>
    (comment) => repo.toggleLikeOnComment(comment);
