import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

typedef LoginUseCase = UseCaseReturn<void> Function(String username, String password);

LoginUseCase newLoginUseCase(AuthRepository repo) => (username, password) => repo.login(username, password);
