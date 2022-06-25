import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

import '../../../../core/helpers/base_tests.dart';
import '../../../../core/helpers/helpers.dart';
import 'shared_for_usecases.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late UpdateProfile sut;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = UpdateProfile(mockProfileRepository);
  });

  final newInfo = ProfileUpdate(newAbout: randomString(), newAvatar: createTestFile());
  test(
    "should forward the call to the repository",
    () async =>
      baseUseCaseTest(
            () => sut(ProfileUpdateParams(newInfo: newInfo)),
            () => mockProfileRepository.updateProfile(newInfo),
        mockProfileRepository,
      )
  );
}
