part of 'auth_gate_cubit.dart';

class AuthState extends Equatable {
  final bool isAuthenticated;
  final Failure? failure;
  @override
  List get props => [isAuthenticated, failure];

  const AuthState([this.isAuthenticated = false, this.failure]);

  AuthState withAuthenticated(bool authenticated) => AuthState(authenticated, failure);
  AuthState withFailure(Failure newFailure) => AuthState(isAuthenticated, newFailure);
  AuthState withoutFailure() => AuthState(isAuthenticated, null);
}
