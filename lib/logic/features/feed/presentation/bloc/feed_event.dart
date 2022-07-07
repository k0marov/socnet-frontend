part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class ScrolledToBottomEvent extends FeedEvent {}

class RefreshedEvent extends FeedEvent {}
