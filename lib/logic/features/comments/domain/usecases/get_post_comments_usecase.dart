import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';

import '../../../posts/domain/entities/post.dart';
import '../entities/comment.dart';

typedef GetPostCommentsUseCase = UseCaseReturn<List<Comment>> Function(Post post);

GetPostCommentsUseCase newGetPostCommentsUseCase(CommentRepository repo) => (post) => repo.getPostComments(post);
