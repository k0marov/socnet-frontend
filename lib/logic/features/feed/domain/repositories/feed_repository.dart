import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<Post>>> getNextPosts(int amount);
}
