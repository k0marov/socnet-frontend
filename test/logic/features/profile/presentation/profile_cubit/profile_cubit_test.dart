import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/presentation/profile_cubit/profile_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';
import '../../shared.dart';

abstract class ToggleFollow {
  UseCaseReturn<Profile> call(Profile _);
}

class MockToggleFollow extends Mock implements ToggleFollow {}

void main() {
  final tProfile = createTestProfile();

  late MockToggleFollow mockToggleFollow;
  late ProfileCubit sut;

  setUp(() {
    mockToggleFollow = MockToggleFollow();
    sut = profileCubitFactoryImpl(mockToggleFollow)(tProfile);
  });

  final initialState = ProfileState(tProfile);

  test("should have initial state with the provided profile", () {
    expect(sut.state, initialState);
  });

  group("FollowToggled", () {
    Future setUpUseCaseAndAct(Either<Failure, Profile> useCaseReturn) async {
      when(() => mockToggleFollow(tProfile)).thenAnswer((_) async => useCaseReturn);
      await sut.followToggled();
    }

    test("should change the profile and remove failure from state if usecase call is successful", () async {
      final wantUpdProfile = createTestProfile();
      await setUpUseCaseAndAct(Right(wantUpdProfile));
      expect(sut.state, initialState.withoutFailure().withProfile(wantUpdProfile));
    });
    test("should add failure to state if usecase throws", () async {
      final tFailure = randomFailure();
      await setUpUseCaseAndAct(Left(tFailure));
      expect(sut.state, initialState.withFailure(tFailure));
    });
  });
}
