import 'package:socnet/logic/core/error/exception_to_failure.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/logic/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/logic/features/feed/domain/repositories/feed_repository.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedNetworkDataSource _dataSource;
  FeedRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Post>>> getNextPosts(int amount) async {
    return exceptionToFailureCall(() async {
      final postsMapper = await _dataSource.getNextPosts(amount);
      return postsMapper.map((postModel) => postModel.toEntity()).toList();
    });
  }
}
