import 'package:equatable/equatable.dart';

import '../../../profile/data/models/profile_model.dart';
import '../../domain/entities/comment.dart';

class CommentModel extends Equatable {
  final Comment _entity;
  @override
  List get props => [_entity];

  Comment toEntity() => _entity;

  const CommentModel(this._entity);

  CommentModel.fromJson(Map<String, dynamic> json)
      : this(Comment(
          id: json['pk'].toString(),
          author: ProfileModel.fromJson(json['author']).toEntity(),
          createdAt: DateTime.parse(json['created_at']),
          text: json['text'],
          likes: json['likes'],
          isMine: json['is_mine'],
          isLiked: json['is_liked'],
        ));
  Map<String, dynamic> toJson() => {
        'pk': int.parse(_entity.id),
        'author': ProfileModel(_entity.author).toJson(),
        'created_at': _entity.createdAt.toIso8601String(),
        'text': _entity.text,
        'likes': _entity.likes,
        'is_liked': _entity.isLiked,
        'is_mine': _entity.isMine,
      };
}
