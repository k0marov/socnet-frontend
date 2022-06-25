import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../../domain/entities/my_profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileNetworkDataSource _dataSource;
  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile) async {
    // ignore: prefer_function_declarations_over_variables
    final call = () => _dataSource.getFollows(ProfileModel(profile)).then(
        (modelList) => modelList.map((model) => model.toEntity()).toList());
    return _exceptionSafeCall(call);
  }

  @override
  Future<Either<Failure, MyProfile>> getMyProfile() async {
    return _exceptionSafeCall(
        () => _dataSource.getMyProfile().then((model) => model.toEntity()));
  }

  @override
  Future<Either<Failure, MyProfile>> updateProfile(ProfileUpdate update) async {
    return _exceptionSafeCall(
      () => _dataSource.updateProfile(update).then((model) => model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> toggleFollow(Profile profile) async {
    return _exceptionSafeCall(
        () => _dataSource.toggleFollow(ProfileModel(profile)));
  }

  Future<Either<Failure, T>> _exceptionSafeCall<T>(
      Future<T> Function() func) async {
    try {
      final result = await func();
      return Right(result);
    } on NoTokenException {
      return Left(NoTokenFailure());
    } catch (e) {
      return Left(NetworkFailure.fromException(e as NetworkException));
    }
  }
}
