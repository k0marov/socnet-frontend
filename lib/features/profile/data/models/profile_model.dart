import 'package:equatable/equatable.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

class ProfileModel extends Equatable {
  final Profile _entity;
  @override
  List get props => [_entity];

  Profile toEntity() => _entity;

  const ProfileModel(this._entity);

  ProfileModel.fromJson(Map<String, dynamic> json)
      : this(
          Profile(
            id: json['id'],
            username: json['username'],
            avatarUrl: json['avatar_url'],
            about: json['about'],
            followers: json['followers'],
            follows: json['follows'],
            isMine: json['is_mine'],
            isFollowed: json['is_followed'],
          ),
        );
  Map<String, dynamic> toJson() => {
        'id': _entity.id,
        'username': _entity.username,
        'about': _entity.about,
        'avatar_url': _entity.avatarUrl,
        'followers': _entity.followers,
        'follows': _entity.follows,
        'is_mine': _entity.isMine,
        'is_followed': _entity.isFollowed,
      };
}
