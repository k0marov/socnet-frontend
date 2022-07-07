import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_avatar.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import 'shared_for_usecases.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late UpdateAvatar sut;
  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = UpdateAvatar(mockProfileRepository);
  });
  final newAvatar = createTestFile();
  test(
      "should forward the call to repository",
      () async => baseUseCaseTest(
            () => sut(AvatarParams(newAvatar: newAvatar)),
            () => mockProfileRepository.updateAvatar(newAvatar),
            mockProfileRepository,
          ));
}