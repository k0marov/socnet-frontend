import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/toggle_follow_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ToggleFollowUseCase _toggleFollow;
  ProfileCubit(this._toggleFollow, Profile profile) : super(ProfileState(profile));

  Future<void> followToggled() async {
    final result = await _toggleFollow(state.profile);
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => emit(state.withoutFailure().withProfile(state.profile.withIsFollowed(!state.profile.isFollowed))),
    );
  }
}

typedef ProfileCubitFactory = ProfileCubit Function(Profile);
ProfileCubitFactory profileCubitFactoryImpl(ToggleFollowUseCase toggleFollow) =>
    (profile) => ProfileCubit(toggleFollow, profile);
