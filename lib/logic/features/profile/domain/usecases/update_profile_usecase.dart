import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../entities/profile.dart';

typedef UpdateProfileUseCase = UseCaseReturn<Profile> Function(ProfileUpdate upd);

UpdateProfileUseCase newUpdateProfileUseCase(ProfileRepository repo) => (upd) => repo.updateProfile(upd);
