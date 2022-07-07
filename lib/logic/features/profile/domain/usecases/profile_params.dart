import 'package:equatable/equatable.dart';

import '../entities/profile.dart';

class ProfileParams extends Equatable {
  final Profile profile;
  @override
  List get props => [profile];
  const ProfileParams({required this.profile});
}
