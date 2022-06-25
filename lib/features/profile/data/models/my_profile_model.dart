import 'package:equatable/equatable.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../../domain/entities/my_profile.dart';

class MyProfileModel extends Equatable {
  final MyProfile _entity;
  MyProfile toEntity() => _entity;
  @override
  List get props => [_entity];
  const MyProfileModel(this._entity);

  MyProfileModel.fromJson(Map<String, dynamic> json)
      : this(MyProfile(
          profile: _jsonToProfile(json),
          follows: (json['followsProfiles'] as List)
              .map((profileJson) => _jsonToProfile(profileJson))
              .toList(),
        ));
  Map<String, dynamic> toJson() => {
        ..._profileToJson(_entity.profile),
        'followsProfiles':
            _entity.follows.map((profile) => _profileToJson(profile)).toList()
      };
  static Map<String, dynamic> _profileToJson(Profile profile) =>
      ProfileModel(profile).toJson();
  static Profile _jsonToProfile(Map<String, dynamic> json) =>
      ProfileModel.fromJson(json).toEntity();
}
