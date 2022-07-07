import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../values/avatar.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getMyProfile();
  Future<Either<Failure, Profile>> getProfile(String id);
  Future<Either<Failure, List<Profile>>> getFollows(Profile profile);
  Future<Either<Failure, void>> toggleFollow(Profile profile);
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdate update);
  Future<Either<Failure, AvatarURL>> updateAvatar(AvatarFile newAvatar);
}
