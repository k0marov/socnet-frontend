import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';

typedef CreatePostUseCase = UseCaseReturn<void> Function(NewPostValue newPost);

CreatePostUseCase newCreatePostUseCase(PostRepository repo) => (newPost) => repo.createPost(newPost);
