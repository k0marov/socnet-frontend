part of 'comments_bloc.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {
  const CommentsLoading();
}

class CommentsLoadingFailure extends CommentsLoading {
  final Failure failure;
  @override
  List get props => [failure];
  const CommentsLoadingFailure({required this.failure});
}

class CommentsLoaded extends CommentsState {
  final Post post;
  final List<Comment> comments;
  @override
  List get props => [post, comments];

  const CommentsLoaded({required this.post, required this.comments});
}

class CommentsLoadedFailure extends CommentsLoaded {
  final Failure failure;
  @override
  List get props => [post, comments, failure];
  const CommentsLoadedFailure({
    required this.failure,
    required super.post,
    required super.comments,
  });
}
