part of 'post_creation_bloc.dart';

abstract class PostCreationEvent extends Equatable {
  const PostCreationEvent();

  @override
  List get props => [];
}

class ImageAdded extends PostCreationEvent {
  final SimpleFile newImage;
  @override
  List get props => [newImage];
  const ImageAdded({required this.newImage});
}

class ImageDeleted extends PostCreationEvent {
  final SimpleFile deletedImage;
  @override
  List get props => [deletedImage];
  const ImageDeleted({required this.deletedImage});
}

class PostButtonPressed extends PostCreationEvent {
  final String finalText;
  @override
  List get props => [finalText];
  const PostButtonPressed({required this.finalText});
}
