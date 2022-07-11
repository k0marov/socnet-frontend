import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_my_profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../../../../../core/usecase.dart';
import '../../../domain/usecases/update_avatar.dart';
import '../../../domain/values/avatar.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final GetMyProfile _getMyProfile;
  final UpdateProfile _updateInfo;
  final UpdateAvatar _updateAvatar;
  MyProfileBloc(this._getMyProfile, this._updateInfo, this._updateAvatar) : super(const MyProfileInitial()) {
    on<MyProfileEvent>((event, emit) async {
      final currentState = state;
      final currentProfile = currentState is MyProfileLoaded ? currentState.profile : null;
      if (event is ProfileLoadRequested) {
        emit(const MyProfileLoading());
        final profileEither = await _getMyProfile(NoParams());
        profileEither.fold(
          (failure) => emit(MyProfileFailure(failure)),
          (profile) => emit(MyProfileLoaded(profile)),
        );
      } else if (event is ProfileUpdateRequested) {
        if (currentProfile == null) return;
        final profileEither = await _updateInfo(ProfileUpdateParams(newInfo: event.profileUpdate));
        profileEither.fold(
          (failure) => emit(MyProfileLoaded(currentProfile, failure)),
          (profile) => emit(MyProfileLoaded(profile)),
        );
      } else if (event is AvatarUpdateRequested) {
        if (currentProfile == null) return;
        final newAvatarEither = await _updateAvatar(AvatarParams(newAvatar: event.newAvatar));
        newAvatarEither.fold(
          (failure) => emit(MyProfileLoaded(currentProfile, failure)),
          (newURL) {
            final updatedProfile = Profile(
              id: currentProfile.id,
              username: currentProfile.username,
              about: currentProfile.about,
              avatarUrl: Some(newURL),
              followers: currentProfile.followers,
              follows: currentProfile.follows,
              isMine: currentProfile.isMine,
              isFollowed: currentProfile.isFollowed,
            );
            emit(MyProfileLoaded(updatedProfile));
          },
        );
      }
    });
  }
}
