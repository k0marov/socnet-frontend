import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../entities/post.dart';

typedef GetProfilePostsUseCase = UseCaseReturn<List<Post>> Function(Profile profile);

GetProfilePostsUseCase newGetProfilePostsUseCase(PostRepository repo) => (profile) => repo.getProfilePosts(profile);
