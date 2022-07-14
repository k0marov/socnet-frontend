part of 'post_creation_cubit.dart';

class PostCreationState extends Equatable {
  final List<SimpleFile> images;
  final FieldValue text;
  final bool isCreated;

  final Failure? failure;

  bool get canSubmit => images.isNotEmpty || text.value.isNotEmpty;

  @override
  List get props => [images, text, failure, isCreated];

  const PostCreationState() : this._(const [], const FieldValue(), false, null);

  const PostCreationState._(this.images, this.text, this.isCreated, this.failure);

  PostCreationState withImages(Iterable<SimpleFile> images) =>
      PostCreationState._(images.toList(), text, isCreated, failure);
  PostCreationState withText(FieldValue text) => PostCreationState._(images, text, isCreated, failure);
  PostCreationState withFailure(Failure failure) => PostCreationState._(images, text, isCreated, failure);
  PostCreationState withoutFailures() => PostCreationState._(images, text.withoutFailure(), isCreated, null);
  PostCreationState makeCreated() => PostCreationState._(images, text, true, failure);
}
