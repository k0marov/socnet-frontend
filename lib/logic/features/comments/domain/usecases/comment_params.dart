import 'package:equatable/equatable.dart';

import '../entities/comment.dart';

class CommentParams extends Equatable {
  final Comment comment;
  @override
  List get props => [comment];

  const CommentParams({required this.comment});
}
