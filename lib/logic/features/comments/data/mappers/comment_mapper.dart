import 'package:socnet/logic/core/error/exceptions.dart';

import '../../../../core/mapper.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../domain/entities/comment.dart';

typedef CommentMapper = Mapper<Comment>;

class CommentMapperImpl implements CommentMapper {
  @override
  Comment fromJson(Map<String, dynamic> json) {
    try {
      return Comment(
        id: json['id'],
        author: ProfileModel.fromJson(json['author']).toEntity(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toUtc(),
        text: json['text'],
        likes: json['likes'],
        isMine: json['is_mine'],
        isLiked: json['is_liked'],
      );
    } catch (e) {
      throw MappingException();
    }
  }
}
