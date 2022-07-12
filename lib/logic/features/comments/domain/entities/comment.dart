import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

import '../../../../core/likeable.dart';

class Comment extends Equatable {
  final String id;
  final Profile author;
  final DateTime createdAt;
  final String text;
  final bool isMine;
  final Likeable _likeable;

  bool get isLiked => _likeable.isLiked;
  int get likes => _likeable.likes;

  @override
  List get props => [id, author, createdAt, text, likes, isMine, isLiked];

  Comment({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.text,
    required this.isMine,
    required int likes,
    required bool isLiked,
  }) : _likeable = Likeable(likes: likes, isLiked: isLiked);

  const Comment._(this.id, this.author, this.createdAt, this.text, this.isMine, this._likeable);

  Comment withLikeToggled() => Comment._(id, author, createdAt, text, isMine, _likeable.withLikeToggled());
}
