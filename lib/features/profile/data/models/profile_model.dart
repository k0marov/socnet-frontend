import 'package:equatable/equatable.dart';
import 'package:socnet/core/mappers/url_mapper.dart';
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
            id: json['pk'].toString(),
            username: json['username'],
            avatarUrl: json['avatar'] != null
                ? URLMapper().shortToLong(json['avatar'])
                : null,
            about: json['about'],
            followers: json['followers'],
            follows: json['follows'],
          ),
        );
  Map<String, dynamic> toJson() => {
        'pk': int.parse(_entity.id),
        'username': _entity.username,
        'about': _entity.about,
        'avatar': _entity.avatarUrl != null
            ? URLMapper().longToShort(_entity.avatarUrl!)
            : null,
        'followers': _entity.followers,
        'follows': _entity.follows,
      };
}
