import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/profile/data/mappers/profile_mapper.dart';

import '../../../../core/mapper.dart';

typedef PostMapper = Mapper<Post>;

class PostMapperImpl implements PostMapper {
  @override
  Post fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        id: json['id'].toString(),
        author: ProfileMapperImpl().fromJson(json['author']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000, isUtc: true),
        images: (json['images'] as List)
            .map<PostImage>((imageJson) => PostImage(imageJson['index'], imageJson['url']))
            .toList(),
        text: json['text'],
        likes: json['likes'],
        isLiked: json['is_liked'],
        isMine: json['is_mine'],
      );
    } catch (e) {
      throw MappingException();
    }
  }
}
