import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../../../../core/error/helpers.dart';
import '../datasources/profile_network_datasource.dart';
import '../values/avatar.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getMyProfile();
  Future<Either<Failure, Profile>> getProfile(String id);
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile);
  Future<Either<Failure, Profile>> toggleFollow(Profile profile);
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate update);
  Future<Either<Failure, AvatarURL>> updateAvatar(AvatarFile newAvatar);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileNetworkDataSource _dataSource;
  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile) async {
    return failureToLeft(() => _dataSource.getFollows(profile));
  }

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
    return failureToLeft(() => _dataSource.getMyProfile());
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate update) async {
    return failureToLeft(() => _dataSource.updateProfile(update));
  }

  @override
  Future<Either<Failure, Profile>> toggleFollow(Profile profile) async {
    return failureToLeft(() => _dataSource.toggleFollow(profile).then((_) => profile.withFollowToggled()));
  }

  @override
  Future<Either<Failure, AvatarURL>> updateAvatar(AvatarFile newAvatar) async {
    return failureToLeft(() => _dataSource.updateAvatar(newAvatar));
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    return failureToLeft(() => _dataSource.getProfile(id));
  }
}
