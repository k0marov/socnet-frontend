part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List get props => [];
}

class FollowToggled extends ProfileEvent {}
