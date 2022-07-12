import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';

import '../entities/profile.dart';

typedef ToggleFollowUseCase = UseCaseReturn<Profile> Function(Profile profile);

ToggleFollowUseCase newToggleFollowUseCase(ProfileRepository repo) => (profile) => repo.toggleFollow(profile);
