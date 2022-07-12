import 'dart:convert';

import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/features/profile/data/mappers/profile_mapper.dart';
import 'package:socnet/logic/features/profile/domain/values/avatar.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../../../../core/error/helpers.dart';
import '../../domain/entities/profile.dart';

abstract class ProfileNetworkDataSource {
  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<List<Profile>> getFollows(Profile profile);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<void> toggleFollow(Profile profile);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<Profile> getMyProfile();

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<Profile> getProfile(String id);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<Profile> updateProfile(ProfileUpdate update);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<AvatarURL> updateAvatar(AvatarFile newAvatar);
}

class ProfileNetworkDataSourceImpl implements ProfileNetworkDataSource {
  final ProfileMapper _mapper;
  final AuthenticatedAPIFacade _apiFacade;
  ProfileNetworkDataSourceImpl(this._mapper, this._apiFacade);

  @override
  Future<List<Profile>> getFollows(Profile profile) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(getFollowsEndpoint(profile.id));
      checkStatusCode(response);

      final profiles = json.decode(response.body)['profiles'];
      return profiles.map<Profile>((profileJson) => _mapper.fromJson(profileJson)).toList();
    });
  }

  @override
  Future<Profile> getMyProfile() async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(getMyProfileEndpoint());
      checkStatusCode(response);
      final profileJson = json.decode(response.body);
      return _mapper.fromJson(profileJson);
    });
  }

  @override
  Future<Profile> updateProfile(ProfileUpdate update) async {
    return exceptionConverterCall(() async {
      final data = update.newAbout != null ? {'about': update.newAbout!} : <String, String>{};

      final response = await _apiFacade.put(updateProfileEndpoint(), data);
      checkStatusCode(response);

      final profileJson = json.decode(response.body);
      return _mapper.fromJson(profileJson);
    });
  }

  @override
  Future<void> toggleFollow(Profile profile) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.post(toggleFollowEndpoint(profile.id), {});
      checkStatusCode(response);
    });
  }

  @override
  Future<AvatarURL> updateAvatar(AvatarFile newAvatar) async {
    return exceptionConverterCall(() async {
      final files = {"avatar": newAvatar};
      final response = await _apiFacade.sendFiles("PUT", updateAvatarEndpoint(), files, {});
      checkStatusCode(response);
      return json.decode(response.body)['avatar_url'];
    });
  }

  @override
  Future<Profile> getProfile(String id) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(getProfileEndpoint(id));
      checkStatusCode(response);
      final profileJson = json.decode(response.body);
      return _mapper.fromJson(profileJson);
    });
  }
}
