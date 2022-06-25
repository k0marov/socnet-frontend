import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/entities/token_entity.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<Token, RegisterParams> {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);
  @override
  Future<Either<Failure, Token>> call(RegisterParams params) async {
    return _repository.register(params.username, params.password);
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String password;

  @override
  List get props => [username, password];

  const RegisterParams({
    required this.username,
    required this.password,
  });
}
