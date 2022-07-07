part of 'post_creation_bloc.dart';

abstract class PostCreationState extends Equatable {
  const PostCreationState();

  @override
  List get props => [];
}

class DefaultCreationState extends PostCreationState {
  final List<SimpleFile> images;
  final String? currentSavedText;
  @override
  List get props => [images, currentSavedText];

  const DefaultCreationState(
      {required this.images, required this.currentSavedText});
}

class CreationSuccessful extends PostCreationState {}

class CreationFailed extends DefaultCreationState {
  final Failure failure;
  @override
  List get props => [failure, images, currentSavedText];

  const CreationFailed({
    required this.failure,
    required super.images,
    required super.currentSavedText,
  });
}
