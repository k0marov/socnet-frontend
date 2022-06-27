import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';
import 'package:socnet/features/profile/domain/usecases/toggle_follow.dart';

import '../../shared.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ToggleFollow sut;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    sut = ToggleFollow(mockProfileRepository);
  });

  test(
    "should call usecase and return the result",
    () async {
      // arrange
      const tResult = Left(NetworkFailure.unknown);
      final tProfile = createTestProfile();
      when(() => mockProfileRepository.toggleFollow(tProfile)).thenAnswer((_) async => tResult);
      // act
      final result = await sut(ProfileParams(profile: tProfile));
      // assert
      expect(result, tResult);
      verify(() => mockProfileRepository.toggleFollow(tProfile));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );
}
