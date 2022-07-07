part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final Failure? nonFatalFailure;
  @override
  List get props => [profile, nonFatalFailure];

  const ProfileLoaded(this.profile, [this.nonFatalFailure]);
}
