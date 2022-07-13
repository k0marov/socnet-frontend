import 'package:socnet/logic/features/profile/domain/values/avatar.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../../domain/entities/profile.dart';

abstract class ProfileNetworkDataSource {
  /// throws:
  /// [NoTokenFailure]
  /// [NetworkFailure]
  Future<List<Profile>> getFollows(Profile profile);

  /// throws:
  /// [NoTokenFailure]
  /// [NetworkFailure]
  Future<void> toggleFollow(Profile profile);

  /// throws:
  /// [NoTokenFailure]
  /// [NetworkFailure]
  Future<Profile> getMyProfile();

  /// throws:
  /// [NoTokenFailure]
  /// [NetworkFailure]
  Future<Profile> getProfile(String id);

  /// throws:
  /// [NoTokenFailure]
  /// [NetworkFailure]
  Future<Profile> updateProfile(ProfileUpdate update);

  /// throws:
  /// [NoTokenFailure]
  /// [NetworkFailure]
  Future<AvatarURL> updateAvatar(AvatarFile newAvatar);
}
