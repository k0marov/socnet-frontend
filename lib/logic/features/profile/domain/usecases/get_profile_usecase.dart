import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';

import '../../../../core/usecase.dart';
import '../entities/profile.dart';

typedef GetProfileUseCase = UseCaseReturn<Profile> Function(String id);

GetProfileUseCase newGetProfileUseCase(ProfileRepository repo) => (id) => repo.getProfile(id);
