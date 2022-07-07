import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String username;
  final String about;
  final String? avatarUrl;
  final int followers;
  final int follows;
  final bool isMine;
  final bool isFollowed;

  @override
  List get props => [id, username, about, avatarUrl, followers, follows, isMine, isFollowed];

  const Profile({
    required this.id,
    required this.username,
    required this.about,
    required this.avatarUrl,
    required this.followers,
    required this.follows,
    required this.isMine,
    required this.isFollowed,
  });
}