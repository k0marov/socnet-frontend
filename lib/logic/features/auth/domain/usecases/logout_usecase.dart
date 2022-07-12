import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

typedef LogoutUseCase = UseCaseReturn<void> Function();

LogoutUseCase newLogoutUseCase(AuthRepository repo) => () => repo.logout();
