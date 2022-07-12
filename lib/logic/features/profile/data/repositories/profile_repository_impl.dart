import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/exception_to_failure.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/logic/features/profile/domain/values/avatar.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileNetworkDataSource _dataSource;
  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile) async {
    return exceptionToFailureCall(() => _dataSource.getFollows(profile));
  }

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
    return exceptionToFailureCall(() => _dataSource.getMyProfile());
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate update) async {
    return exceptionToFailureCall(() => _dataSource.updateProfile(update));
  }

  @override
  Future<Either<Failure, Profile>> toggleFollow(Profile profile) async {
    return exceptionToFailureCall(() => _dataSource.toggleFollow(profile).then((_) => profile.withLikeToggled()));
  }

  @override
  Future<Either<Failure, AvatarURL>> updateAvatar(AvatarFile newAvatar) async {
    return exceptionToFailureCall(() => _dataSource.updateAvatar(newAvatar));
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    return exceptionToFailureCall(() => _dataSource.getProfile(id));
  }
}
