import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/usecases/get_my_profile.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';
import 'package:socnet/features/profile/domain/usecases/toggle_follow.dart';
import 'package:socnet/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/features/profile/domain/values/profile_update.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';



// TODO: create a bloc that will store current user's follows and handle the ToggleFollow

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final GetMyProfile _getMyProfile;
  final UpdateProfile _updateInfo;
  MyProfileBloc(this._getMyProfile, this._updateInfo)
      : super(const MyProfileInitial()) {
    on<MyProfileEvent>((event, emit) async {
      final currentState = state;
      final currentProfileData =
          currentState is MyProfileLoaded ? currentState.profile : null;
      if (event is ProfileLoadRequested) {
        emit(const MyProfileLoading());
        final profileEither = await _getMyProfile(NoParams());
        profileEither.fold(
          (failure) => emit(MyProfileFailure(failure)),
          (profile) => emit(MyProfileLoaded(profile)),
        );
      } else if (event is ProfileUpdateRequested) {
        if (currentProfileData == null) return;
        final profileEither = await _updateInfo(
            ProfileUpdateParams(newInfo: event.profileUpdate));
        profileEither.fold(
          (failure) => emit(MyProfileLoaded(currentProfileData, failure)),
          (profile) => emit(MyProfileLoaded(profile)),
        );
      }
    });
  }
}
