import 'package:dartz/dartz.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecase.dart';
import 'package:socnet/features/profile/domain/entities/profile.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/features/profile/domain/usecases/profile_params.dart';

class GetFollows extends UseCase<List<Profile>, ProfileParams> {
  final ProfileRepository _repository;
  const GetFollows(this._repository);
  @override
  Future<Either<Failure, List<Profile>>> call(ProfileParams params) async {
    return _repository.getFollows(params.profile);
  }
}
