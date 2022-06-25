import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/features/feed/domain/usecases/get_next_feed_posts.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';

import '../../../../core/error/failures.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetNextFeedPosts _getNextFeedPosts;
  final int _loadAmount;
  FeedBloc(this._getNextFeedPosts, this._loadAmount) : super(FeedInitial()) {
    on<FeedEvent>((event, emit) async {
      final currentState = state;
      if (event is ScrolledToBottomEvent) {
        if (currentState is FeedLoading) return;

        final currentPosts =
            currentState is FeedLoaded ? currentState.currentPosts : <Post>[];
        emit(FeedLoading(currentPosts: currentPosts));

        final resultEither =
            await _getNextFeedPosts(FeedParams(amount: _loadAmount));

        resultEither.fold(
          (failure) => emit(FeedFailure(
            failure: failure,
            currentPosts: currentPosts,
          )),
          (newPosts) => emit(FeedLoaded(currentPosts: currentPosts + newPosts)),
        );
      } else if (event is RefreshedEvent) {
        if (currentState is FeedLoading) return;

        emit(const FeedLoading());
        final resultEither =
            await _getNextFeedPosts(FeedParams(amount: _loadAmount));

        resultEither.fold(
          (failure) => emit(FeedFailure(failure: failure)),
          (fetchedPosts) => emit(FeedLoaded(currentPosts: fetchedPosts)),
        );
      }
    });
  }
}

// for simple get it injection
class FeedBlocCreator {
  final GetNextFeedPosts _getNextFeedPosts;
  FeedBlocCreator(this._getNextFeedPosts);

  FeedBloc create({required int amountOfPostsPerLoad}) => FeedBloc(
        _getNextFeedPosts,
        amountOfPostsPerLoad,
      );
}
