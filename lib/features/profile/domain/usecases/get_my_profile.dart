import 'package:socnet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/my_profile.dart';

class GetMyProfile extends UseCase<MyProfile, NoParams> {
  final ProfileRepository _repository;
  const GetMyProfile(this._repository);

  @override
  Future<Either<Failure, MyProfile>> call(NoParams params) async {
    return _repository.getMyProfile();
  }
}
