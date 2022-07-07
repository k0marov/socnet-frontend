part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List get props => [];
}

class GetComments extends CommentsEvent {
  final Post post;
  @override
  List get props => [post];
  const GetComments({required this.post});
}

class CommentDeleted extends CommentsEvent {
  final Comment deletedComment;
  @override
  List get props => [deletedComment];
  const CommentDeleted({required this.deletedComment});
}

class CommentAdded extends CommentsEvent {
  final NewCommentValue newComment;
  @override
  List get props => [newComment];
  const CommentAdded({required this.newComment});
}

class CommentLikePressed extends CommentsEvent {
  final Comment targetComment;
  @override
  List get props => [targetComment];
  const CommentLikePressed({required this.targetComment});
}
