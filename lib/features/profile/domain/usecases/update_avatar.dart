import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecase.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';

import '../values/avatar.dart';

class UpdateAvatar extends UseCase<AvatarURL, AvatarParams> {
  final ProfileRepository _repository;
  const UpdateAvatar(this._repository);

  @override
  Future<Either<Failure, AvatarURL>> call(AvatarParams params) {
    return _repository.updateAvatar(params.newAvatar);
  }
}

class AvatarParams extends Equatable {
  final AvatarFile newAvatar;
  @override
  List get props => [newAvatar];
  const AvatarParams({required this.newAvatar});
}
