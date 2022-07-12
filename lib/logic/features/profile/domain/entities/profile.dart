import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/likeable.dart';

import '../values/avatar.dart';

class Profile extends Equatable {
  final String id;
  final String username;
  final String about;
  final Option<AvatarURL> avatarUrl;
  final int follows;
  final bool isMine;
  final Likeable _likeable;

  int get followers => _likeable.likes;
  bool get isFollowed => _likeable.isLiked;

  @override
  List get props => [id, username, about, avatarUrl, followers, follows, isMine, isFollowed];

  Profile({
    required this.id,
    required this.username,
    required this.about,
    required this.avatarUrl,
    required this.follows,
    required this.isMine,
    required int followers,
    required bool isFollowed,
  }) : _likeable = Likeable(likes: followers, isLiked: isFollowed);

  const Profile._(this.id, this.username, this.about, this.avatarUrl, this.follows, this.isMine, this._likeable);

  Profile withLikeToggled() => _copyWith(likeable: _likeable.withLikeToggled());
  Profile withAbout(String about) => _copyWith(about: about);
  Profile withAvatarUrl(Option<String> avatarUrl) => _copyWith(avatarUrl: avatarUrl);

  Profile _copyWith(
          {String? id,
          String? username,
          String? about,
          Option<String>? avatarUrl,
          int? follows,
          bool? isMine,
          Likeable? likeable}) =>
      Profile._(
        id ?? this.id,
        username ?? this.username,
        about ?? this.about,
        avatarUrl ?? this.avatarUrl,
        follows ?? this.follows,
        isMine ?? this.isMine,
        likeable ?? _likeable,
      );
}
