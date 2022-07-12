import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/usecase.dart';
import '../entities/profile.dart';

typedef GetMyProfileUseCase = UseCaseReturn<Profile> Function();

GetMyProfileUseCase newGetMyProfileUseCase(ProfileRepository repo) => () => repo.getMyProfile();
