import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

typedef GetAuthTokenUseCase = UseCaseReturn<Token> Function();

GetAuthTokenUseCase newGetAuthTokenUseCase(AuthRepository repo) => () => repo.getToken();
