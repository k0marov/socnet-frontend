import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/field_value.dart';
import 'failure_handler.dart';

part 'post_creation_state.dart';

class PostCreationCubit extends Cubit<PostCreationState> {
  final CreatePostUseCase _createPost;
  final PostCreationFailureHandler _failureHandler;
  PostCreationCubit(this._createPost, this._failureHandler) : super(PostCreationState());

  void imageAdded(SimpleFile newImg) => emit(state.withImages(state.images + [newImg]));
  void imageDeleted(SimpleFile target) => emit(state.withImages(state.images.where((i) => i != target)));
  void imageReordered(int curIndex, int newIndex) {
    final images = state.images.toList();
    if (curIndex < 0 || curIndex >= images.length || newIndex < 0 || newIndex >= images.length) return;
    final targetImg = images[curIndex];
    images.removeAt(curIndex);
    images.insert(newIndex, targetImg);
    emit(state.withImages(images));
  }

  void textChanged(String text) => emit(state.withText(state.text.withValue(text)));

  Future<void> submitPressed() async {
    final result = await _createPost(NewPostValue(
      images: state.images,
      text: state.text.value,
    ));
    result.fold(
      (failure) => emit(_failureHandler(state.withoutFailures(), failure)),
      (success) => emit(state.withoutFailures().makeCreated()),
    );
  }
}

typedef PostCreationCubitFactory = PostCreationCubit Function();

PostCreationCubitFactory postCreationCubitFactoryImpl(
  CreatePostUseCase createPost,
  PostCreationFailureHandler failureHandler,
) =>
    () => PostCreationCubit(createPost, failureHandler);
