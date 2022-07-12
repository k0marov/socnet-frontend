import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';

import '../values/avatar.dart';

typedef UpdateAvatarUseCase = UseCaseReturn<AvatarURL> Function(AvatarFile avatar);

UpdateAvatarUseCase newUpdateAvatarUseCase(ProfileRepository repo) => (avatar) => repo.updateAvatar(avatar);
