import 'package:dartz/dartz.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/usecase.dart';
import '../entities/profile.dart';

class GetMyProfile extends UseCase<Profile, NoParams> {
  final ProfileRepository _repository;
  const GetMyProfile(this._repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return _repository.getMyProfile();
  }
}
