import 'dart:convert';

import 'package:socnet/core/authenticated_api_facade.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/values/avatar.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../../../../core/error/helpers.dart';

abstract class ProfileNetworkDataSource {
  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<List<ProfileModel>> getFollows(ProfileModel profile);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<void> toggleFollow(ProfileModel profile);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<ProfileModel> getMyProfile();

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<ProfileModel> getProfile(String id);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<ProfileModel> updateProfile(ProfileUpdate update);

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<AvatarURL> updateAvatar(AvatarFile newAvatar);
}

class ProfileNetworkDataSourceImpl implements ProfileNetworkDataSource {
  final AuthenticatedAPIFacade _apiFacade;
  ProfileNetworkDataSourceImpl(this._apiFacade);

  @override
  Future<List<ProfileModel>> getFollows(ProfileModel profile) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(getFollowsEndpoint(profile.toEntity().id));
      checkStatusCode(response);

      final profiles = json.decode(response.body)['profiles'];
      return profiles.map<ProfileModel>((profileJson) => ProfileModel.fromJson(profileJson)).toList();
    });
  }

  @override
  Future<ProfileModel> getMyProfile() async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(getMyProfileEndpoint());
      checkStatusCode(response);
      final profileJson = json.decode(response.body);
      return ProfileModel.fromJson(profileJson);
    });
  }

  @override
  Future<ProfileModel> updateProfile(ProfileUpdate update) async {
    return exceptionConverterCall(() async {
      final data = update.newAbout != null ? {'about': update.newAbout!} : <String, String>{};

      final response = await _apiFacade.put(updateProfileEndpoint(), data);
      checkStatusCode(response);

      final profileJson = json.decode(response.body);
      return ProfileModel.fromJson(profileJson);
    });
  }

  @override
  Future<void> toggleFollow(ProfileModel profile) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.post(toggleFollowEndpoint(profile.toEntity().id), {});
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
  Future<ProfileModel> getProfile(String id) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.get(getProfileEndpoint(id));
      checkStatusCode(response);
      final profileJson = json.decode(response.body);
      return ProfileModel.fromJson(profileJson);
    });
  }
}
