import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_token_stream_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final Failure? failure;
  @override
  List get props => [isAuthenticated, failure];
  const AuthState(this.isAuthenticated, [this.failure]);
}

typedef AuthGateStream = Stream<AuthState>;

AuthGateStream AuthGateStreamFactory(GetTokenStreamUseCase getTokenStream) => getTokenStream(NoParams()).map(
      (event) => event.fold(
        (failure) => AuthState(false, failure),
        (tokenOption) => AuthState(tokenOption.isSome()),
      ),
    );
