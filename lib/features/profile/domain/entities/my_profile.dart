import 'package:equatable/equatable.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

class MyProfile extends Equatable {
  final Profile profile;
  final List<Profile> follows;
  @override
  List get props => [profile, follows];
  const MyProfile({
    required this.profile,
    required this.follows,
  });
}
