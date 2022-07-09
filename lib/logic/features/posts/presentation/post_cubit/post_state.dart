part of 'post_cubit.dart';

class PostState extends Equatable {
  final Post post;
  final Failure? failure;
  final bool isDeleted;

  @override
  List get props => [post, failure, isDeleted];

  const PostState(this.post, [this.failure, this.isDeleted = false]);

  PostState withPost(Post newPost) => PostState(newPost, failure, isDeleted);
  PostState withoutFailure() => PostState(post, null, isDeleted);
  PostState withFailure(Failure newFailure) => PostState(post, newFailure, isDeleted);

  PostState makeDeleted() => PostState(post, null, true);
}
