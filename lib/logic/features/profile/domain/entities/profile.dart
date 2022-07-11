import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String username;
  final String about;
  final Option<String> avatarUrl;
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

  Profile withAbout(String about) => _copyWith(about: about);
  Profile withIsFollowed(bool isFollowed) => _copyWith(isFollowed: isFollowed);
  Profile withAvatarUrl(Option<String> avatarUrl) => _copyWith(avatarUrl: avatarUrl);

  Profile _copyWith(
          {String? id,
          String? username,
          String? about,
          Option<String>? avatarUrl,
          int? followers,
          int? follows,
          bool? isMine,
          bool? isFollowed}) =>
      Profile(
        id: id ?? this.id,
        username: username ?? this.username,
        about: about ?? this.about,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        followers: followers ?? this.followers,
        follows: follows ?? this.follows,
        isMine: isMine ?? this.isMine,
        isFollowed: isFollowed ?? this.isFollowed,
      );
}
