import 'dart:convert';

import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../../../../core/error/helpers.dart';
import '../../../../core/simple_file/simple_file.dart';
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
      final response = await _apiFacade.get(getFollowsEndpoint(profile.toEntity().id), {});
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
      final response = await _apiFacade.get(getMyProfileEndpoint(), {});
      checkStatusCode(response);
      final profileJson = json.decode(response.body);
      return MyProfileModel.fromJson(profileJson);
    });
  }

  @override
  Future<MyProfileModel> updateProfile(ProfileUpdate update) async {
    return exceptionConverterCall(() async {
      final files = update.newAvatar != null ? {'avatar': update.newAvatar!} : <String, SimpleFile>{};
      final data = update.newAbout != null ? {'about': update.newAbout!} : <String, String>{};

      final response = await _apiFacade.sendFiles("PUT", updateProfileEndpoint(), files, data);
      checkStatusCode(response);

      final profileJson = json.decode(response.body);
      return MyProfileModel.fromJson(profileJson);
    });
  }

  @override
  Future<void> toggleFollow(ProfileModel profile) async {
    return exceptionConverterCall(() async {
      final response = await _apiFacade.post(toggleFollowEndpoint(profile.toEntity().id), {});
      checkStatusCode(response);
    });
  }
}
