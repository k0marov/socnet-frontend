import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';
import 'package:socnet/features/profile/domain/usecases/toggle_follow.dart';
import 'package:socnet/features/profile/presentation/profile/bloc/profile_bloc.dart';

import '../../../../core/helpers/helpers.dart';
import '../../shared.dart';

class MockToggleFollow extends Mock implements ToggleFollow {}

void main() {
  final tProfile = createTestProfile();

  late MockToggleFollow mockToggleFollow;
  late ProfileBloc sut;
  setUp(() {
    mockToggleFollow = MockToggleFollow();
    sut = ProfileBloc(tProfile, mockToggleFollow);
  });

  test("should have initial state = Loaded with profile provided via constructor", () {
    expect(sut.state, ProfileLoaded(tProfile));
  });
  group("FollowToggled", () {
    void setUpUseCaseAndAct(Either<Failure, void> useCaseReturn) {
      when(() => mockToggleFollow(ProfileParams(profile: tProfile))).thenAnswer((_) async => useCaseReturn);
      sut.add(FollowToggled());
    }

    test("should call toggle follow usecase", () async {
      setUpUseCaseAndAct(const Right(null));
      await untilCalled(() => mockToggleFollow(ProfileParams(profile: tProfile)));
    });

    test("should update state to Loaded if usecase call is successful", () async {
      final wantUpdProfile = Profile(
        id: tProfile.id,
        username: tProfile.username,
        about: tProfile.about,
        avatarUrl: tProfile.avatarUrl,
        followers: tProfile.followers,
        follows: tProfile.follows,
        isMine: tProfile.isMine,
        isFollowed: !tProfile.isFollowed, // toggle the value
      );
      expect(sut.stream, emitsInOrder([ProfileLoaded(wantUpdProfile)]));
      setUpUseCaseAndAct(const Right(null));
    });
    test("should set state to Loaded with failure if usecase call throws", () async {
      final tFailure = randomFailure();
      expect(sut.stream, emitsInOrder([ProfileLoaded(tProfile, tFailure)]));
      setUpUseCaseAndAct(Left(tFailure));
    });
  });
}
