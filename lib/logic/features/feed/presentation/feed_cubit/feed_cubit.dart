import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../posts/domain/entities/post.dart';
import '../../domain/usecases/get_next_feed_posts_usecase.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final GetNextFeedPostsUseCase _getPosts;
  final int _loadAmount;
  FeedCubit(this._getPosts, this._loadAmount) : super(const FeedState());

  Future<void> scrolledToBottom() async {
    if (state.isLoading) return;
    emit(state.withIsLoading(true));
    final result = await _getPosts(_loadAmount);
    result.fold(
      (failure) => emit(state.withIsLoading(false).withFailure(failure)),
      (fetchedPosts) => emit(state.withIsLoading(false).withoutFailure().withPosts(state.posts + fetchedPosts)),
    );
  }

  void refreshed() => state.isLoading ? null : emit(const FeedState());
}

typedef FeedCubitFactory = FeedCubit Function(int loadAmount);

FeedCubitFactory feedCubitFactoryImpl(GetNextFeedPostsUseCase getPosts) =>
    (loadAmount) => FeedCubit(getPosts, loadAmount);
