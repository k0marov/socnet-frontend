import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/repositories/profile_repository.dart';

typedef GetFollowsUseCase = UseCaseReturn<List<Profile>> Function(Profile profile);

GetFollowsUseCase newGetFollowsUseCase(ProfileRepository repo) => (profile) => repo.getFollows(profile);
