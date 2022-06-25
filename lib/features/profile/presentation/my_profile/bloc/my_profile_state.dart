part of 'my_profile_bloc.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List get props => [];
}

class MyProfileInitial extends MyProfileState {
  const MyProfileInitial();
}

class MyProfileLoading extends MyProfileState {
  const MyProfileLoading();
}

class MyProfileFailure extends MyProfileState {
  final Failure failure;
  @override
  List get props => [failure];

  const MyProfileFailure(this.failure);
}

class MyProfileLoaded extends MyProfileState {
  final MyProfile profile;
  final Failure? nonFatalFailure;
  @override
  List get props => [profile, nonFatalFailure];
  const MyProfileLoaded(this.profile, [this.nonFatalFailure]);
}
