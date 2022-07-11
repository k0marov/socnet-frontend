part of 'my_profile_cubit.dart';

class MyProfileState extends Equatable {
  final Profile profile;
  final Failure? failure;

  @override
  List get props => [profile, failure];

  const MyProfileState(this.profile, [this.failure]);

  MyProfileState withProfile(Profile profile) => MyProfileState(profile, failure);
  MyProfileState withFailure(Failure failure) => MyProfileState(profile, failure);
  MyProfileState withoutFailure() => MyProfileState(profile, null);
}
