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

class AvatarUpdateRequested extends MyProfileEvent {
  final AvatarFile newAvatar;
  @override
  List<Object> get props => [newAvatar];
  const AvatarUpdateRequested({required this.newAvatar});
}
