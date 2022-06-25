part of 'my_profile_bloc.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadRequested extends MyProfileEvent {}

class ProfileUpdateRequested extends MyProfileEvent {
  final ProfileUpdate profileUpdate;
  @override
  List<Object> get props => [profileUpdate];

  const ProfileUpdateRequested({required this.profileUpdate});
}

class ProfileToggleFollowRequested extends MyProfileEvent {
  final Profile profile;
  @override
  List<Object> get props => [profile];
  const ProfileToggleFollowRequested({required this.profile});
}
