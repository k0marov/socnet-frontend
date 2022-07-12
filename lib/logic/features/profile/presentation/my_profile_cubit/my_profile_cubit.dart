import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/simple_file.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/update_avatar_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/values/profile_update.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UpdateProfileUseCase _updateProfile;
  final UpdateAvatarUseCase _updateAvatar;

  MyProfileCubit(this._updateProfile, this._updateAvatar, Profile myProfile) : super(MyProfileState(myProfile));

  Future<void> updateProfile(ProfileUpdate upd) async {
    final result = await _updateProfile(upd);
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (updProfile) => emit(state.withoutFailure().withProfile(updProfile)),
    );
  }

  Future<void> updateAvatar(SimpleFile avatar) async {
    final result = await _updateAvatar(avatar);
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (newAvatar) => emit(state.withoutFailure().withProfile(state.profile.withAvatarUrl(Some(newAvatar)))),
    );
  }
}

typedef MyProfileCubitFactory = MyProfileCubit Function(Profile);
MyProfileCubitFactory myProfileCubitFactoryImpl(
  UpdateProfileUseCase updateProfile,
  UpdateAvatarUseCase updateAvatar,
) =>
    (myProfile) => MyProfileCubit(updateProfile, updateAvatar, myProfile);
