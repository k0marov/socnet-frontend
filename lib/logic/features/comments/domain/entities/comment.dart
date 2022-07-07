import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

class Comment extends Equatable {
  final String id;
  final Profile author;
  final DateTime createdAt;
  final String text;
  final int likes;
  final bool isMine;
  final bool isLiked;
  @override
  List get props => [id, author, createdAt, text, likes, isMine, isLiked];

  const Comment({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.text,
    required this.likes,
    required this.isMine,
    required this.isLiked,
  });
}
