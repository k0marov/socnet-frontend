import 'package:equatable/equatable.dart';

class ProfileUpdate extends Equatable {
  final String? newAbout;

  @override
  List get props => [newAbout];

  const ProfileUpdate({
    required this.newAbout,
  });
}
