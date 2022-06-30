import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/exception_to_failure.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/features/profile/domain/values/avatar.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileNetworkDataSource _dataSource;
  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile) async {
    return exceptionToFailureCall(
        () => _dataSource.getFollows(ProfileModel(profile)).then((modelList) => modelList.map((model) => model.toEntity()).toList()));
  }

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
    return exceptionToFailureCall(() => _dataSource.getMyProfile().then((model) => model.toEntity()));
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate update) async {
    return exceptionToFailureCall(
      () => _dataSource.updateProfile(update).then((model) => model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> toggleFollow(Profile profile) async {
    return exceptionToFailureCall(() => _dataSource.toggleFollow(ProfileModel(profile)));
  }

  @override
  Future<Either<Failure, AvatarURL>> updateAvatar(AvatarFile newAvatar) async {
    return exceptionToFailureCall(() => _dataSource.updateAvatar(newAvatar));
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    return exceptionToFailureCall(() => _dataSource.getProfile(id).then((model) => model.toEntity()));
  }
}
