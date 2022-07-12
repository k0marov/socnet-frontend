import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';

import '../entities/post.dart';

typedef DeletePostUseCase = UseCaseReturn<void> Function(Post post);

DeletePostUseCase newDeletePostUseCase(PostRepository repo) => (post) => repo.deletePost(post);
