import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/profile/domain/usecases/get_follows.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';
import 'package:mocktail/mocktail.dart';

import '../../shared.dart';
import 'shared_for_usecases.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late GetFollows sut;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = GetFollows(mockProfileRepository);
  });

  test('should forward the call to the repository', () async {
    // arrange
    final tProfile = createTestProfile();
    final follows = [
      createTestProfile(),
      createTestProfile(),
      createTestProfile()
    ];
    when(() => mockProfileRepository.getFollows(tProfile))
        .thenAnswer((_) async => Right(follows));
    // act
    final result = await sut(ProfileParams(profile: tProfile));
    // assert
    result.fold(
      (failure) => throw AssertionError(),
      (profiles) => expect(identical(profiles, follows), true),
    );
  });
}
