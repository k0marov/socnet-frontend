import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/profile/domain/usecases/get_my_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../shared.dart';
import 'shared_for_usecases.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late GetMyProfile sut;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = GetMyProfile(mockProfileRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      final tProfile = createTestProfile();
      when(() => mockProfileRepository.getMyProfile())
          .thenAnswer((_) async => Right(tProfile));
      // act
      final result = await sut(NoParams());
      // assert
      result.fold(
        (failure) => throw AssertionError(),
        (profile) => expect(identical(profile, tProfile), true),
      );
    },
  );
}
