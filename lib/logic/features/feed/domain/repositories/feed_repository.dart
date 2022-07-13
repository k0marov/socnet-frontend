import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../core/error/helpers.dart';
import '../datasources/feed_network_datasource.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<Post>>> getNextPosts(int amount);
}

class FeedRepositoryImpl implements FeedRepository {
  final FeedNetworkDataSource _dataSource;
  FeedRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Post>>> getNextPosts(int amount) async {
    return failureToLeft(() => _dataSource.getNextPosts(amount));
  }
}
