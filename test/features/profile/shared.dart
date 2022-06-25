import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../../core/fixtures/fixture_reader.dart';
import '../../core/helpers/helpers.dart';

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
