import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../entities/profile.dart';

class UpdateProfile extends UseCase<Profile, ProfileUpdateParams> {
  final ProfileRepository _repository;
  const UpdateProfile(this._repository);

  @override
  Future<Either<Failure, Profile>> call(ProfileUpdateParams params) async {
    return _repository.updateProfile(params.newInfo);
  }
}

class ProfileUpdateParams extends Equatable {
  final ProfileUpdate newInfo;
  @override
  List get props => [newInfo];
  const ProfileUpdateParams({required this.newInfo});
}
