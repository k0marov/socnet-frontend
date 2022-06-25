import 'package:equatable/equatable.dart';
import 'package:socnet/core/simple_file/simple_file.dart';

class ProfileUpdate extends Equatable {
  final String? newAbout;

  @override
  List get props => [newAbout];

  const ProfileUpdate({
    required this.newAbout,
  });
}
