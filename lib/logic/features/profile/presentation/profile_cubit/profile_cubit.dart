import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/profile_params.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/toggle_follow.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ToggleFollow _toggleFollow;
  ProfileCubit(this._toggleFollow, Profile profile) : super(ProfileState(profile));

  Future<void> followToggled() async {
    final result = await _toggleFollow(ProfileParams(profile: state.profile));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => emit(state.withoutFailure().withProfile(state.profile.withIsFollowed(!state.profile.isFollowed))),
    );
  }
}

typedef ProfileCubitFactory = ProfileCubit Function(Profile);
ProfileCubitFactory profileCubitFactoryImpl(ToggleFollow toggleFollow) =>
    (profile) => ProfileCubit(toggleFollow, profile);
