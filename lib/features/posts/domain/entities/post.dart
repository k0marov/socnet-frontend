import 'package:equatable/equatable.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

class Post extends Equatable {
  final String id;
  final Profile author;
  final bool isMine;
  final DateTime createdAt;
  final List<String> images;
  final String text;
  final int likes;
  final bool isLiked;

  @override
  List get props =>
      [id, author, isMine, createdAt, images, text, likes, isLiked];

  const Post({
    required this.id,
    required this.author,
    required this.isMine,
    required this.createdAt,
    required this.images,
    required this.text,
    required this.likes,
    required this.isLiked,
  });
}
