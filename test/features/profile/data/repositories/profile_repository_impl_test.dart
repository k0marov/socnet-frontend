import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/features/profile/data/models/my_profile_model.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:socnet/features/profile/domain/entities/my_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../shared.dart';

class MockProfileNetworkDataSource extends Mock
    implements ProfileNetworkDataSource {}

void main() {
  late ProfileRepositoryImpl sut;
  late MockProfileNetworkDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProfileNetworkDataSource();
    sut = ProfileRepositoryImpl(mockDataSource);
  });

  void _baseExceptionTests(When Function() whenApiCall, Function sutCall) {
    test(
      "should return NoTokenFailure if datasource throws NoTokenException",
      () async {
        // arrange
        whenApiCall().thenThrow(NoTokenException());
        // act
        final result = await sutCall();
        // assert
        expect(result, Left(NoTokenFailure()));
      },
    );
    test(
      "should return NetworkFailure if datasource throws NoTokenException",
      () async {
        // arrange
        whenApiCall().thenThrow(const NetworkException(42, "some detail"));
        // act
        final result = await sutCall();
        // assert
        expect(result, const Left(NetworkFailure(42, "some detail")));
      },
    );
  }

  group('getFollows', () {
    final tProfile = createTestProfile();
    test(
      "should call datasource and return the result if call is successful",
      () async {
        // arrange
        final tFollows = [
          createTestProfile(),
          createTestProfile(),
          createTestProfile()
        ];
        final tFollowsModels =
            tFollows.map((profile) => ProfileModel(profile)).toList();
        when(() => mockDataSource.getFollows(ProfileModel(tProfile)))
            .thenAnswer((_) async => tFollowsModels);
        // act
        final result = await sut.getFollows(tProfile);
        // assert
        result.fold(
          (failure) => throw AssertionError(),
          (profileList) => expect(profileList, tFollows),
        );
        verify(() => mockDataSource.getFollows(ProfileModel(tProfile)));
        verifyNoMoreInteractions(mockDataSource);
      },
    );
    _baseExceptionTests(
      () => when(() => mockDataSource.getFollows(ProfileModel(tProfile))),
      () => sut.getFollows(tProfile),
    );
  });

  group('getMyProfile', () {
    test(
      "should call datasource and return the result if it was successful",
      () async {
        // arrange
        final tProfile =
            MyProfile(profile: createTestProfile(), follows: const []);
        when(() => mockDataSource.getMyProfile())
            .thenAnswer((_) async => MyProfileModel(tProfile));
        // act
        final result = await sut.getMyProfile();
        // assert
        expect(result, Right(tProfile));
        verify(() => mockDataSource.getMyProfile());
        verifyNoMoreInteractions(mockDataSource);
      },
    );
    _baseExceptionTests(
      () => when(() => mockDataSource.getMyProfile()),
      () => sut.getMyProfile(),
    );
  });

  group('updateProfile', () {
    final tProfileUpdate = createTestProfileUpdate();
    final tProfile = MyProfile(profile: createTestProfile(), follows: const []);
    test(
      "should call the datasource and return the result if it was successful",
      () async {
        // arrange
        when(() => mockDataSource.updateProfile(tProfileUpdate))
            .thenAnswer((_) async => MyProfileModel(tProfile));
        // act
        final result = await sut.updateProfile(tProfileUpdate);
        // assert
        expect(result, Right(tProfile));
        verify(() => mockDataSource.updateProfile(tProfileUpdate));
        verifyNoMoreInteractions(mockDataSource);
      },
    );
    _baseExceptionTests(
      () => when(() => mockDataSource.updateProfile(tProfileUpdate)),
      () => sut.updateProfile(tProfileUpdate),
    );
  });

  group('toggleFollow', () {
    final tProfile = createTestProfile();
    final tProfileModel = ProfileModel(tProfile);
    test(
      "should call the datasource and return nothing if it was successful",
      () async {
        // arrange
        when(() => mockDataSource.toggleFollow(tProfileModel))
            .thenAnswer((_) async {});
        // act
        final result = await sut.toggleFollow(tProfile);
        // assert
        expect(result, const Right(null));
        verify(() => mockDataSource.toggleFollow(tProfileModel));
        verifyNoMoreInteractions(mockDataSource);
      },
    );
    _baseExceptionTests(
      () => when(() => mockDataSource.toggleFollow(tProfileModel)),
      () => sut.toggleFollow(tProfile),
    );
  });
}
