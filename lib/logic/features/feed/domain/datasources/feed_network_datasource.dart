import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

abstract class FeedNetworkDataSource {
  /// Throws [NoTokenFailure] and [NetworkFailure]
  Future<List<Post>> getNextPosts(int amount);
}
