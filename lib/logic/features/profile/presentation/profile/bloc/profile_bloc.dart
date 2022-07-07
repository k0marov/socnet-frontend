import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/profile/domain/usecases/profile_params.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/profile.dart';
import '../../../domain/usecases/toggle_follow.dart';

part 'profile_event.dart';
part 'profile_state.dart';

// this is used to allow for simple GetIt injection
class ProfileBlocCreator {
  final ToggleFollow _toggleFollow;
  const ProfileBlocCreator(this._toggleFollow);

  ProfileBloc create(Profile profile) => ProfileBloc(profile, _toggleFollow);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ToggleFollow _toggleFollow;
  ProfileBloc(Profile profile, this._toggleFollow) : super(ProfileLoaded(profile)) {
    on<ProfileEvent>((event, emit) async {
      if (event is FollowToggled) {
        final curState = state;
        if (curState is! ProfileLoaded) return;
        final curProfile = curState.profile;
        final resultEither = await _toggleFollow(ProfileParams(profile: curState.profile));
        resultEither.fold(
          (failure) => emit(ProfileLoaded(curProfile, failure)),
          (success) {
            final toggledProfile = Profile(
              id: curProfile.id,
              username: curProfile.username,
              about: curProfile.about,
              avatarUrl: curProfile.avatarUrl,
              followers: curProfile.followers,
              follows: curProfile.follows,
              isMine: curProfile.isMine,
              isFollowed: !curProfile.isFollowed,
            );
            emit(ProfileLoaded(toggledProfile));
          },
        );
      }
    });
  }
}
