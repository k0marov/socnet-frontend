import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_profile.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../shared.dart';
import 'shared_for_usecases.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late UpdateProfile sut;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = UpdateProfile(mockProfileRepository);
  });

  final newInfo = createTestProfileUpdate();
  test(
      "should forward the call to the repository",
      () async => baseUseCaseTest(
            () => sut(ProfileUpdateParams(newInfo: newInfo)),
            () => mockProfileRepository.updateProfile(newInfo),
            mockProfileRepository,
          ));
}
