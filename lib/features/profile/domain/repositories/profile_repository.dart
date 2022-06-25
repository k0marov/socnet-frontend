import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../entities/my_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, MyProfile>> getMyProfile();
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile);
  Future<Either<Failure, void>> toggleFollow(Profile profile);
  Future<Either<Failure, MyProfile>> updateProfile(ProfileUpdate update);
}
