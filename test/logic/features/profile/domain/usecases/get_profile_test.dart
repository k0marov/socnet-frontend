import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_profile.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import 'shared_for_usecases.dart';

void main() {
  final mockRepository = MockProfileRepository();
  final sut = GetProfile(mockRepository);
  final profileId = randomString();
  test(
    "should forward the call to the repository",
    () => baseUseCaseTest(
        () => sut(ProfileIDParams(profileId)), () => mockRepository.getProfile(profileId), mockRepository),
  );
}
