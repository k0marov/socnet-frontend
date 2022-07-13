import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../core/mapper.dart';

typedef ProfileMapper = Mapper<Profile>;

class ProfileMapperImpl implements ProfileMapper {
  @override
  Profile fromJson(Map<String, dynamic> json) {
    try {
      return Profile(
        id: json['id'],
        username: json['username'],
        avatarUrl: json['avatar_url'] != null ? Some(json['avatar_url']) : const None(),
        about: json['about'],
        followers: json['followers'],
        follows: json['follows'],
        isMine: json['is_mine'],
        isFollowed: json['is_followed'],
      );
    } catch (e) {
      throw MappingFailure();
    }
  }
}
