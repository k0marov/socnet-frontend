import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/logic/features/feed/domain/repositories/feed_repository.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../core/error/helpers.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedNetworkDataSource _dataSource;
  FeedRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Post>>> getNextPosts(int amount) async {
    return failureToLeft(() => _dataSource.getNextPosts(amount));
  }
}
