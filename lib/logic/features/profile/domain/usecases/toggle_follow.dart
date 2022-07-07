import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/logic/features/profile/domain/usecases/profile_params.dart';

class ToggleFollow extends UseCase<void, ProfileParams> {
  final ProfileRepository _repository;
  ToggleFollow(this._repository);
  @override
  Future<Either<Failure, void>> call(ProfileParams params) async {
    return _repository.toggleFollow(params.profile);
  }
}