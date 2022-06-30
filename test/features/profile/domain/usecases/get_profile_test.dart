import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/profile/domain/usecases/get_profile.dart';

import '../../../../core/helpers/base_tests.dart';
import '../../../../core/helpers/helpers.dart';
import 'shared_for_usecases.dart';

void main() {
  final mockRepository = MockProfileRepository();
  final sut = GetProfile(mockRepository);
  final profileId = randomString();
  test(
    "should forward the call to the repository",
    () => baseUseCaseTest(() => sut(ProfileIDParams(profileId)), () => mockRepository.getProfile(profileId), mockRepository),
  );
}
