import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/features/posts/domain/entities/post.dart';
import 'package:socnet/features/posts/domain/usecases/delete_post.dart';
import 'package:socnet/features/posts/domain/usecases/post_params.dart';
import 'package:socnet/features/posts/domain/usecases/toggle_like.dart';

import '../../../../core/error/failures.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final DeletePost deletePost;
  final ToggleLike toggleLike;
  PostBloc(Post loadedPost, this.deletePost, this.toggleLike)
      : super(PostLoaded(loadedPost)) {
    on<PostEvent>((event, emit) async {
      final currentState = state;
      if (currentState is! PostLoaded) return;
      final post = currentState.post;

      if (event is PostDeletedEvent) {
        emit(PostDeleting(post));
        final result = await deletePost(PostParams(post: currentState.post));
        result.fold(
          (failure) => emit(PostFailure(post, failure)),
          (success) => emit(PostDeletedState()),
        );
      } else if (event is LikeToggled) {
        emit(PostLikeUpdating(post));
        final result = await toggleLike(PostParams(post: currentState.post));
        result.fold(
          (failure) => emit(PostFailure(post, failure)),
          (likedPost) => emit(PostLoaded(likedPost)),
        );
      }
    });
  }
}

// the actual class is private and this class is used instead to allow for simple GetIt injection
class PostBlocCreator {
  final DeletePost deletePost;
  final ToggleLike toggleLike;

  const PostBlocCreator(this.deletePost, this.toggleLike);

  PostBloc create(Post loadedPost) => PostBloc(
        loadedPost,
        deletePost,
        toggleLike,
      );
}
