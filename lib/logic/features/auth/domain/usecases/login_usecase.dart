import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase extends UseCase<void, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(LoginParams params) async {
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
