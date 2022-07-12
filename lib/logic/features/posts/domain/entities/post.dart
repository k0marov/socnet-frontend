import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/likeable.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

class PostImage extends Equatable {
  final int index;
  final String url;
  @override
  List get props => [index, url];
  const PostImage(this.index, this.url);
}

class Post extends Equatable {
  final String id;
  final Profile author;
  final bool isMine;
  final DateTime createdAt;
  final List<PostImage> images;
  final String text;
  final Likeable _likeable;

  int get likes => _likeable.likes;
  bool get isLiked => _likeable.isLiked;

  @override
  List get props => [id, author, isMine, createdAt, images, text, likes, isLiked];

  Post({
    required this.id,
    required this.author,
    required this.isMine,
    required this.createdAt,
    required this.images,
    required this.text,
    required int likes,
    required bool isLiked,
  }) : _likeable = Likeable(likes: likes, isLiked: isLiked);

  const Post._(this.id, this.author, this.isMine, this.createdAt, this.images, this.text, this._likeable);

  Post withLikeToggled() => Post._(id, author, isMine, createdAt, images, text, _likeable.withLikeToggled());
}
