part of 'comments_cubit.dart';

class CommentsState extends Equatable {
  final List<Comment> comments;
  final Failure? failure;
  @override
  List get props => [comments, failure];
  const CommentsState(this.comments, [this.failure]);

  CommentsState withComments(Iterable<Comment> comments) => CommentsState(comments.toList(), failure);
  CommentsState withoutFailure() => CommentsState(comments);
  CommentsState withFailure(Failure newFailure) => CommentsState(comments, newFailure);
}
