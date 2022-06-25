import 'dart:convert';

import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../../../../core/error/helpers.dart';
import '../models/my_profile_model.dart';

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
  Future<MyProfileModel> getMyProfile();

  /// throws:
  /// [NoTokenException]
  /// [NetworkException]
  Future<MyProfileModel> updateProfile(ProfileUpdate update);
}

class ProfileNetworkDataSourceImpl implements ProfileNetworkDataSource {
  final AuthenticatedAPIFacade _apiFacade;
  ProfileNetworkDataSourceImpl(this._apiFacade);

  @override
  Future<List<ProfileModel>> getFollows(ProfileModel profile) async {
    return exceptionConverterCall(() async {
      final fullEndpoint = "profiles/${profile.toEntity().id}/follows/";
      final response = await _apiFacade.get(fullEndpoint, {});
      checkStatusCode(response);

      final profiles = json.decode(response.body)['profiles'];
      return profiles
          .map<ProfileModel>(
              (profileJson) => ProfileModel.fromJson(profileJson))
          .toList();
    });
  }

  @override
  Future<MyProfileModel> getMyProfile() async {
    return exceptionConverterCall(() async {
      const endpoint = "profiles/me/";

      final response = await _apiFacade.get(endpoint, {});
      checkStatusCode(response);
      final profileJson = json.decode(response.body);
      return MyProfileModel.fromJson(profileJson);
    });
  }

  @override
  Future<MyProfileModel> updateProfile(ProfileUpdate update) async {
    return exceptionConverterCall(() async {
      const endpoint = "profiles/me/";

      final files = {'avatar': update.newAvatar};
      final data = {'about': update.newAbout};

      final response = await _apiFacade.sendFiles("PUT", endpoint, files, data);
      checkStatusCode(response);

      final profileJson = json.decode(response.body);
      return MyProfileModel.fromJson(profileJson);
    });
  }

  @override
  Future<void> toggleFollow(ProfileModel profile) async {
    return exceptionConverterCall(() async {
      final endpoint = "profiles/${profile.toEntity().id}/toggle-follow/";
      final response = await _apiFacade.post(endpoint, {});
      checkStatusCode(response);
    });
  }
}
