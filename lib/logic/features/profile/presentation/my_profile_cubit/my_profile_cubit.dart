import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/simple_file.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/update_avatar.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/values/profile_update.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UpdateProfile _updateProfile;
  final UpdateAvatar _updateAvatar;

  MyProfileCubit(this._updateProfile, this._updateAvatar, Profile myProfile) : super(MyProfileState(myProfile));

  Future<void> updateProfile(ProfileUpdate upd) async {
    final result = await _updateProfile(ProfileUpdateParams(newInfo: upd));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (updProfile) => emit(state.withoutFailure().withProfile(updProfile)),
    );
  }

  Future<void> updateAvatar(SimpleFile avatar) async {
    final result = await _updateAvatar(AvatarParams(newAvatar: avatar));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (newAvatar) => emit(state.withoutFailure().withProfile(state.profile.withAvatarUrl(Some(newAvatar)))),
    );
  }
}

typedef MyProfileCubitFactory = MyProfileCubit Function(Profile);
MyProfileCubitFactory myProfileCubitFactoryImpl(UpdateProfile updateProfile, UpdateAvatar updateAvatar) =>
    (myProfile) => MyProfileCubit(updateProfile, updateAvatar, myProfile);
