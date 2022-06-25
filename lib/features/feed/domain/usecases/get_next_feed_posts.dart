import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/feed/domain/repositories/feed_repository.dart';

import '../../../posts/domain/entities/post.dart';

class GetNextFeedPosts extends UseCase<List<Post>, FeedParams> {
  final FeedRepository _repository;
  GetNextFeedPosts(this._repository);

  @override
  Future<Either<Failure, List<Post>>> call(FeedParams params) async {
    return _repository.getNextPosts(params.amount);
  }
}

class FeedParams extends Equatable {
  final int amount;
  @override
  List get props => [amount];
  const FeedParams({required this.amount});
}
