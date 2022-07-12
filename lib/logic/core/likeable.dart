import 'package:equatable/equatable.dart';

class Likeable extends Equatable {
  final int likes;
  final bool isLiked;
  @override
  List get props => [likes, isLiked];
  const Likeable({required this.likes, required this.isLiked});

  Likeable withLikeToggled() => isLiked
      ? Likeable(
          likes: likes - 1,
          isLiked: false,
        )
      : Likeable(
          likes: likes + 1,
          isLiked: true,
        );
}
