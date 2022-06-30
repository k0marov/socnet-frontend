import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/data/repositories/profile_repository_impl.dart';

import '../../../../core/helpers/base_tests.dart';
import '../../../../core/helpers/helpers.dart';
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
    final tFollowsModels = tFollows.map((profile) => ProfileModel(profile)).toList();
    baseRepositoryTests(
      () => sut.getFollows(tProfile),
      () => mockDataSource.getFollows(ProfileModel(tProfile)),
      tFollowsModels,
      (result) => listEquals(result, tFollows),
      () => mockDataSource,
    );
  });

  group('getMyProfile', () {
    final tProfile = createTestProfile();
    final tProfileModel = ProfileModel(tProfile);
    baseRepositoryTests(
      () => sut.getMyProfile(),
      () => mockDataSource.getMyProfile(),
      tProfileModel,
      (result) => result == tProfile,
      () => mockDataSource,
    );
  });
  group('getProfile', () {
    final tProfile = createTestProfile();
    final tProfileModel = ProfileModel(tProfile);
    final tId = randomString();
    baseRepositoryTests(
      () => sut.getProfile(tId),
      () => mockDataSource.getProfile(tId),
      tProfileModel,
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
      ProfileModel(updatedProfile),
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
      () => mockDataSource.toggleFollow(ProfileModel(targetProfile)),
      null,
      (result) => true,
      () => mockDataSource,
    );
  });
}
