import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/logic/features/profile/data/repositories/profile_repository_impl.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import '../../shared.dart';

class MockProfileNetworkDataSource extends Mock implements ProfileNetworkDataSource {}

void main() {
  late ProfileRepositoryImpl sut;
  late MockProfileNetworkDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProfileNetworkDataSource();
    sut = ProfileRepositoryImpl(mockDataSource);
  });

  group('getFollows', () {
    final tProfile = createTestProfile();
    final tFollows = [createTestProfile(), createTestProfile(), createTestProfile()];
    baseRepositoryTests(
      () => sut.getFollows(tProfile),
      () => mockDataSource.getFollows(tProfile),
      tFollows,
      (result) => listEquals(result, tFollows),
      () => mockDataSource,
    );
  });

  group('getMyProfile', () {
    final tProfile = createTestProfile();
    baseRepositoryTests(
      () => sut.getMyProfile(),
      () => mockDataSource.getMyProfile(),
      tProfile,
      (result) => result == tProfile,
      () => mockDataSource,
    );
  });
  group('getProfile', () {
    final tProfile = createTestProfile();
    final tId = randomString();
    baseRepositoryTests(
      () => sut.getProfile(tId),
      () => mockDataSource.getProfile(tId),
      tProfile,
      (result) => result == tProfile,
      () => mockDataSource,
    );
  });

  group('updateProfile', () {
    final profileUpdate = createTestProfileUpdate();
    final updatedProfile = createTestProfile();
    baseRepositoryTests(
      () => sut.updateProfile(profileUpdate),
      () => mockDataSource.updateProfile(profileUpdate),
      updatedProfile,
      (result) => result == updatedProfile,
      () => mockDataSource,
    );
  });

  group('updateAvatar', () {
    final newAvatar = createTestFile();
    final newURL = randomString();
    baseRepositoryTests(
      () => sut.updateAvatar(newAvatar),
      () => mockDataSource.updateAvatar(newAvatar),
      newURL,
      (result) => result == newURL,
      () => mockDataSource,
    );
  });

  group('toggleFollow', () {
    final targetProfile = createTestProfile();
    baseRepositoryTests(
      () => sut.toggleFollow(targetProfile),
      () => mockDataSource.toggleFollow(targetProfile),
      null,
      (result) => result == targetProfile.withFollowToggled(),
      () => mockDataSource,
    );
  });
}
