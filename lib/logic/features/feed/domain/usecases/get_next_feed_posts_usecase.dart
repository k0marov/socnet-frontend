import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/feed/domain/repositories/feed_repository.dart';

import '../../../posts/domain/entities/post.dart';

typedef GetNextFeedPostsUseCase = UseCaseReturn<List<Post>> Function(int amount);

GetNextFeedPostsUseCase newGetNextFeedPostsUseCase(FeedRepository repo) => (amount) => repo.getNextPosts(amount);
