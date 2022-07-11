part of 'feed_cubit.dart';

class FeedState extends Equatable {
  final List<Post> posts;
  final bool isLoading;
  final Failure? failure;
  @override
  List get props => [posts, isLoading, failure];
  const FeedState([this.posts = const [], this.isLoading = false, this.failure]);

  FeedState withPosts(List<Post> posts) => FeedState(posts, isLoading, failure);
  FeedState withIsLoading(bool isLoading) => FeedState(posts, isLoading, failure);
  FeedState withFailure(Failure failure) => FeedState(posts, isLoading, failure);
  FeedState withoutFailure() => FeedState(posts, isLoading, null);
}
