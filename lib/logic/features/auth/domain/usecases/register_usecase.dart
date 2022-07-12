import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

typedef RegisterUseCase = UseCaseReturn<void> Function(String username, String password);

RegisterUseCase newRegisterUseCase(AuthRepository repo) => (username, password) => repo.register(username, password);
