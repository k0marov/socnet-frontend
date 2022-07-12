import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/values/avatar.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile_cubit/my_profile_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';
import '../../shared.dart';

abstract class UpdateProfile {
  UseCaseReturn<Profile> call(ProfileUpdate upd);
}

abstract class UpdateAvatar {
  UseCaseReturn<AvatarURL> call(AvatarFile avatar);
}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockUpdateAvatar extends Mock implements UpdateAvatar {}

void main() {
  late MyProfileCubit sut;
  late MockUpdateProfile mockUpdProfile;
  late MockUpdateAvatar mockUpdateAvatar;

  final tProfile = createTestProfile();

  setUp(() {
    mockUpdProfile = MockUpdateProfile();
    mockUpdateAvatar = MockUpdateAvatar();
    sut = myProfileCubitFactoryImpl(mockUpdProfile, mockUpdateAvatar)(tProfile);
  });

  // setUpAll(() {
  //   registerFallbackValue(ProfileUpdateParams(newInfo: createTestProfileUpdate()));
  //   registerFallbackValue(ProfileParams(profile: tProfile));
  // });

  final initialState = MyProfileState(tProfile);

  test(
    "should have initial state = MyProfileInitial",
    () async {
      // assert
      expect(sut.state, initialState);
    },
  );

  group('ProfileUpdateRequested', () {
    final tUpd = createTestProfileUpdate();
    Future setUpUseCaseAndAct(Either<Failure, Profile> result) async {
      when(() => mockUpdProfile(tUpd)).thenAnswer((_) async => result);
      await sut.updateProfile(tUpd);
    }

    test(
      "should emit Loaded when usecase call completes successfully",
      () async {
        final tUpdated = createTestProfile();
        await setUpUseCaseAndAct(Right(tUpdated));
        expect(sut.state, initialState.withoutFailure().withProfile(tUpdated));
      },
    );
    test(
      "should emit Loaded (with failure and previous profile) when usecase call fails",
      () async {
        final tFailure = randomFailure();
        await setUpUseCaseAndAct(Left(tFailure));
        expect(sut.state, initialState.withFailure(tFailure));
      },
    );
  });
  group("AvatarUpdateRequested", () {
    final tAvatar = createTestFile();
    final tUrl = randomString();
    final updatedProfile = tProfile.withAvatarUrl(Some(tUrl));

    Future setUpUseCaseAndAct(Either<Failure, AvatarURL> result) {
      when(() => mockUpdateAvatar(tAvatar)).thenAnswer((_) async => result);
      return sut.updateAvatar(tAvatar);
    }

    test("should emit Loaded when usecase call compeletes successfuly", () async {
      await setUpUseCaseAndAct(Right(tUrl));
      expect(sut.state, initialState.withoutFailure().withProfile(updatedProfile));
    });
    test("should emit Loaded with error and previous profile if usecase throws", () async {
      final tFailure = randomFailure();
      await setUpUseCaseAndAct(Left(tFailure));
      expect(sut.state, initialState.withFailure(tFailure));
    });
  });
}
