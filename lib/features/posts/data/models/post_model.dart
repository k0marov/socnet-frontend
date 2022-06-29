import 'package:equatable/equatable.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';

import '../../../profile/data/models/profile_model.dart';

class PostModel extends Equatable {
  final Post _entity;
  Post toEntity() => _entity;
  @override
  List get props => [_entity];

  const PostModel(this._entity);

  PostModel.fromJson(Map<String, dynamic> json)
      : this(
          Post(
            id: json['id'].toString(),
            author: ProfileModel.fromJson(json['author']).toEntity(),
            createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000, isUtc: true),
            images: (json['images'] as List).map<PostImage>((imageJson) => PostImage(imageJson['index'], imageJson['url'])).toList(),
            text: json['text'],
            likes: json['likes'],
            isLiked: json['is_liked'],
            isMine: json['is_mine'],
          ),
        );
  Map<String, dynamic> toJson() => {
        'id': _entity.id,
        'author': ProfileModel(_entity.author).toJson(),
        'created_at': (_entity.createdAt.toUtc().millisecondsSinceEpoch / 1000).floor(),
        'images': _entity.images.map((image) => {"index": image.index, "url": image.url}).toList(),
        'text': _entity.text,
        'likes': _entity.likes,
        'is_liked': _entity.isLiked,
        'is_mine': _entity.isMine,
      };
}
