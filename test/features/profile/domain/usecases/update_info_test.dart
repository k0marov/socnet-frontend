import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/profile/domain/entities/my_profile.dart';
import 'package:socnet/features/profile/domain/usecases/update_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../shared.dart';
import 'shared_for_usecases.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late UpdateProfile sut;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = UpdateProfile(mockProfileRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      final tNewInfo = createTestProfileUpdate();
      final tProfile =
          MyProfile(profile: createTestProfile(), follows: const []);
      when(() => mockProfileRepository.updateProfile(tNewInfo))
          .thenAnswer((_) async => Right(tProfile));
      // act
      final result = await sut(ProfileUpdateParams(newInfo: tNewInfo));
      // assert
      result.fold(
        (failure) => throw AssertionError(),
        (profile) => expect(identical(profile, tProfile), true),
      );
    },
  );
}
