import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getMyProfile();
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile);
  Future<Either<Failure, void>> toggleFollow(Profile profile);
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate update);
}
