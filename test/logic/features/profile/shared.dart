import 'package:dartz/dartz.dart';
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
      avatarUrl: randomBool() ? Some(randomString()) : const None(),
      followers: randomInt(),
      follows: randomInt(),
      isMine: randomBool(),
      isFollowed: randomBool(),
    );
