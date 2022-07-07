part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List get props => [];
}

abstract class PostStateWithData extends PostState {
  final Post post;
  @override
  List get props => [post];

  const PostStateWithData(this.post);
}

class PostLoaded extends PostStateWithData {
  const PostLoaded(Post post) : super(post);
}

class PostLikeUpdating extends PostStateWithData {
  const PostLikeUpdating(Post post) : super(post);
}

class PostDeleting extends PostStateWithData {
  const PostDeleting(Post post) : super(post);
}

class PostDeletedState extends PostState {}

class PostFailure extends PostStateWithData {
  final Failure failure;
  @override
  List get props => [failure];
  const PostFailure(Post post, this.failure) : super(post);
}
