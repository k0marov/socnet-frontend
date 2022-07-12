import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/posts/domain/usecases/toggle_like_on_post_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/delete_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final ToggleLikeOnPostUseCase _toggleLike;
  final DeletePostUseCase _deletePost;
  PostCubit(this._toggleLike, this._deletePost, Post post) : super(PostState(post));

  Future<void> likePressed() async {
    final result = await _toggleLike(state.post);
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (likedPost) => emit(state.withoutFailure().withPost(likedPost)),
    );
  }

  Future<void> deletePressed() async {
    final result = await _deletePost(state.post);
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => emit(state.makeDeleted()),
    );
  }
}

typedef PostCubitFactory = PostCubit Function(Post);

PostCubitFactory postCubitFactoryImpl(ToggleLikeOnPostUseCase toggleLike, DeletePostUseCase deletePost) =>
    (post) => PostCubit(toggleLike, deletePost, post);
