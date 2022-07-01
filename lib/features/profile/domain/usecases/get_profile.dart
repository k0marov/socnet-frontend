import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/usecase.dart';
import '../entities/profile.dart';

class GetProfile extends UseCase<Profile, ProfileIDParams> {
  final ProfileRepository _repo;
  const GetProfile(this._repo);
  @override
  Future<Either<Failure, Profile>> call(ProfileIDParams params) {
    return _repo.getProfile(params.profileId);
  }
}

class ProfileIDParams extends Equatable {
  final String profileId;
  @override
  List get props => [profileId];
  const ProfileIDParams(this.profileId);
}
