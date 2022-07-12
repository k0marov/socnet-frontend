import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';

typedef ToggleLikeOnPostUseCase = UseCaseReturn<Post> Function(Post post);

ToggleLikeOnPostUseCase newToggleLikeOnPostUseCase(PostRepository repo) => (post) => repo.toggleLike(post);
