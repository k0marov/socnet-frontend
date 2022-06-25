import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../entities/my_profile.dart';

class UpdateProfile extends UseCase<MyProfile, ProfileUpdateParams> {
  final ProfileRepository _repository;
  const UpdateProfile(this._repository);

  @override
  Future<Either<Failure, MyProfile>> call(ProfileUpdateParams params) async {
    return _repository.updateProfile(params.newInfo);
  }
}

class ProfileUpdateParams extends Equatable {
  final ProfileUpdate newInfo;
  @override
  List get props => [newInfo];
  const ProfileUpdateParams({required this.newInfo});
}
