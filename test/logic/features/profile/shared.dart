import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../../../shared/helpers/helpers.dart';

ProfileUpdate createTestProfileUpdate() => ProfileUpdate(
      newAbout: randomString(),
    );

Profile createTestProfile() => Profile(
      id: randomInt().toString(),
      username: randomString(),
      about: randomString(),
      avatarUrl: randomString(),
      followers: randomInt(),
      follows: randomInt(),
      isMine: randomBool(),
      isFollowed: randomBool(),
    );
