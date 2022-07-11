part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final Profile profile;
  final Failure? failure;
  @override
  List get props => [profile, failure];
  const ProfileState(this.profile, [this.failure]);

  ProfileState withProfile(Profile profile) => ProfileState(profile, failure);
  ProfileState withFailure(Failure failure) => ProfileState(profile, failure);
  ProfileState withoutFailure() => ProfileState(profile);
}
