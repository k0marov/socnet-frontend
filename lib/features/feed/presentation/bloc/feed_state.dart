part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> currentPosts;
  @override
  List get props => [currentPosts];
  const FeedLoaded({required this.currentPosts});
}

class FeedLoading extends FeedLoaded {
  const FeedLoading({super.currentPosts = const []});
}

class FeedFailure extends FeedLoaded {
  final Failure failure;
  @override
  List get props => [failure, currentPosts];
  const FeedFailure({required this.failure, super.currentPosts = const []});
}
