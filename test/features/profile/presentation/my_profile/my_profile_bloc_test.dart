import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/usecases/get_my_profile.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';
import 'package:socnet/features/profile/domain/usecases/toggle_follow.dart';
import 'package:socnet/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/features/profile/presentation/my_profile/bloc/my_profile_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../shared.dart';

class MockGetMyProfile extends Mock implements GetMyProfile {}

class MockUpdateInfo extends Mock implements UpdateProfile {}

void main() {
  late MyProfileBloc sut;
  late MockGetMyProfile mockGetMyProfile;
  late MockUpdateInfo mockUpdateInfo;

  setUp(() {
    mockGetMyProfile = MockGetMyProfile();
    mockUpdateInfo = MockUpdateInfo();
    sut = MyProfileBloc(
      mockGetMyProfile,
      mockUpdateInfo,
    );
  });
  final tProfile = createTestProfile();
  const tFailure = NetworkFailure(4242, "Some detail");

  setUpAll(() {
    registerFallbackValue(
        ProfileUpdateParams(newInfo: createTestProfileUpdate()));
    registerFallbackValue(ProfileParams(profile: tProfile));
  });

  test(
    "should have initial state = MyProfileInitial",
    () async {
      // assert
      expect(sut.state, const MyProfileInitial());
    },
  );

  group('ProfileLoadRequested', () {
    void setupUseCaseAndAct(Either<Failure, Profile> useCaseReturn) {
      when(() => mockGetMyProfile(NoParams()))
          .thenAnswer((_) async => useCaseReturn);
      sut.add(ProfileLoadRequested());
    }

    test(
      "should call GetMyProfile usecase and not call any other usecases",
      () async {
        setupUseCaseAndAct(Right(tProfile));
        // assert
        await untilCalled(() => mockGetMyProfile(NoParams()));
        verify(() => mockGetMyProfile(NoParams()));
        verifyNoMoreInteractions(mockGetMyProfile);
        verifyZeroInteractions(mockUpdateInfo);
      },
    );
    test(
      "should set state to [Loading, Loaded] with the result of usecase call",
      () async {
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              const MyProfileLoading(),
              MyProfileLoaded(tProfile),
            ]));
        setupUseCaseAndAct(Right(tProfile));
      },
    );
    test(
      "should set state to [Loading, Failure] if usecase call returns a failure",
      () async {
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              const MyProfileLoading(),
              const MyProfileFailure(tFailure),
            ]));
        setupUseCaseAndAct(const Left(tFailure));
      },
    );
  });

  group('ProfileUpdateRequested', () {
    final tInfo = createTestProfileUpdate();
    void setUpUseCaseAndAct(Either<Failure, Profile> result) {
      when(() => mockUpdateInfo(ProfileUpdateParams(newInfo: tInfo)))
          .thenAnswer((_) async => result);
      sut.add(ProfileUpdateRequested(profileUpdate: tInfo));
    }

    test(
      "should do nothing if state is not Loaded",
      () async {
        fakeAsync((async) {
          setUpUseCaseAndAct(Right(tProfile));
          async.elapse(const Duration(seconds: 5));
          expect(sut.state, const MyProfileInitial());
          verifyZeroInteractions(mockUpdateInfo);
          verifyZeroInteractions(mockGetMyProfile);
        });
      },
    );
    test(
      "should call profile update usecase if state is Loaded",
      () async {
        // arrange
        sut.emit(MyProfileLoaded(tProfile));
        setUpUseCaseAndAct(Right(tProfile));
        await untilCalled(
            () => mockUpdateInfo(ProfileUpdateParams(newInfo: tInfo)));
        verify(() => mockUpdateInfo(ProfileUpdateParams(newInfo: tInfo)));
        verifyNoMoreInteractions(mockUpdateInfo);
        verifyZeroInteractions(mockGetMyProfile);
      },
    );
    test(
      "should emit Loaded when usecase call completes successfully",
      () async {
        sut.emit(MyProfileLoaded(createTestProfile()));
        // assert later
        expect(sut.stream, emitsInOrder([MyProfileLoaded(tProfile)]));
        setUpUseCaseAndAct(Right(tProfile));
      },
    );
    test(
      "should emit Loaded (with failure and previous profile) when usecase call fails",
      () async {
        sut.emit(MyProfileLoaded(tProfile));
        // assert later
        expect(sut.stream, emitsInOrder([MyProfileLoaded(tProfile, tFailure)]));
        setUpUseCaseAndAct(const Left(tFailure));
      },
    );
  });
}
