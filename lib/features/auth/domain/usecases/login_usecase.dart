import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';

import '../entities/token_entity.dart';

class LoginUseCase extends UseCase<Token, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);
  @override
  Future<Either<Failure, Token>> call(LoginParams params) async {
    return _repository.login(params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  @override
  List get props => [username, password];

  const LoginParams({
    required this.username,
    required this.password,
  });
}
