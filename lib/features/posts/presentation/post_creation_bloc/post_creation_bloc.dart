import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/simple_file/simple_file.dart';
import 'package:socnet/features/posts/domain/usecases/create_post.dart';
import 'package:socnet/features/posts/domain/values/new_post_value.dart';

part 'post_creation_event.dart';
part 'post_creation_state.dart';

class PostCreationBloc extends Bloc<PostCreationEvent, PostCreationState> {
  final CreatePost _createPost;
  PostCreationBloc(this._createPost)
      : super(const DefaultCreationState(images: [], currentSavedText: "")) {
    on<PostCreationEvent>((event, emit) async {
      final currentState = state;
      if (currentState is! DefaultCreationState) return;
      if (event is ImageAdded) {
        final newImages = currentState.images + [event.newImage];
        emit(DefaultCreationState(
          images: newImages,
          currentSavedText: currentState.currentSavedText,
        ));
      } else if (event is ImageDeleted) {
        final newImages = currentState.images
            .where((image) => image != event.deletedImage)
            .toList();
        emit(DefaultCreationState(
          images: newImages,
          currentSavedText: currentState.currentSavedText,
        ));
      } else if (event is PostButtonPressed) {
        final newPostValue =
            NewPostValue(images: currentState.images, text: event.finalText);
        final result =
            await _createPost(PostCreateParams(newPost: newPostValue));
        result.fold(
          (failure) => emit(CreationFailed(
            failure: failure,
            images: currentState.images,
            currentSavedText: event.finalText,
          )),
          (post) => emit(CreationSuccessful()),
        );
      }
    });
  }
}
