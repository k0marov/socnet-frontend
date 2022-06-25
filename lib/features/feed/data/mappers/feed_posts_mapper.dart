import 'package:equatable/equatable.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';

import '../../../posts/domain/entities/post.dart';

class FeedPostsMapper extends Equatable {
  final List<Post> _posts;
  @override
  List get props => [_posts];
  List<Post> toPosts() => _posts;
  const FeedPostsMapper(this._posts);

  Map<String, dynamic> toJson() => {
        'posts': _posts.map((post) => PostModel(post).toJson()).toList(),
      };
  FeedPostsMapper.fromJson(Map<String, dynamic> json)
      : this(
          (json['posts'] as List)
              .map((postJson) => PostModel.fromJson(postJson).toEntity())
              .toList(),
        );
}
