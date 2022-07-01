import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecase.dart';
import 'package:socnet/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/features/posts/domain/usecases/post_params.dart';

class DeletePost extends UseCase<void, PostParams> {
  final PostRepository _repository;
  DeletePost(this._repository);

  @override
  Future<Either<Failure, void>> call(PostParams params) async {
    return _repository.deletePost(params.post);
  }
}
