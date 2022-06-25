import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';

import '../entities/post.dart';

class GetProfilePosts extends UseCase<List<Post>, ProfileParams> {
  final PostRepository _repository;
  GetProfilePosts(this._repository);

  @override
  Future<Either<Failure, List<Post>>> call(ProfileParams params) async {
    return _repository.getProfilePosts(params.profile);
  }
}

class ProfileParams extends Equatable {
  final Profile profile;
  @override
  List get props => [profile];
  const ProfileParams({required this.profile});
}
