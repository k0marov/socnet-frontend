part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List get props => [];
}

class LikeToggled extends PostEvent {}

class PostDeletedEvent extends PostEvent {}
