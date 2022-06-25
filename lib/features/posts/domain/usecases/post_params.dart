import 'package:equatable/equatable.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';

class PostParams extends Equatable {
  final Post post;
  @override
  List get props => [post];
  const PostParams({required this.post});
}
