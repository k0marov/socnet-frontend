import 'package:equatable/equatable.dart';
import 'package:socnet/core/mappers/url_mapper.dart';
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
            id: json['pk'].toString(),
            author: ProfileModel.fromJson(json['author']).toEntity(),
            createdAt: DateTime.parse(json['created_at']),
            images: (json['images'] as List)
                .map<String>((shortUrl) => URLMapper().shortToLong(shortUrl))
                .toList(),
            text: json['text'],
            likes: json['likes'],
            isLiked: json['is_liked'],
            isMine: json['is_mine'],
          ),
        );
  Map<String, dynamic> toJson() => {
        'pk': int.parse(_entity.id),
        'author': ProfileModel(_entity.author).toJson(),
        'created_at': _entity.createdAt.toIso8601String(),
        'images': _entity.images
            .map((longUrl) => URLMapper().longToShort(longUrl))
            .toList(),
        'text': _entity.text,
        'likes': _entity.likes,
        'is_liked': _entity.isLiked,
        'is_mine': _entity.isMine,
      };
}
