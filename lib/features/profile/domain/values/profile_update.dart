import 'package:equatable/equatable.dart';
import 'package:socnet/core/simple_file/simple_file.dart';

class ProfileUpdate extends Equatable {
  final String? newAbout;
  final SimpleFile? newAvatar;

  @override
  List get props => [newAbout, newAvatar];

  const ProfileUpdate({
    required this.newAbout,
    required this.newAvatar,
  });
}
