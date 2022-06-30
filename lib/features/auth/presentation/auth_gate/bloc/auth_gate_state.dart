part of 'auth_gate_bloc.dart';

abstract class AuthGateState extends Equatable {
  const AuthGateState();

  @override
  List get props => [];
}

class AuthGateInitial extends AuthGateState {}

class AuthGateAuthenticated extends AuthGateState {
  final Failure? failure;
  @override
  List get props => [failure];
  const AuthGateAuthenticated([this.failure]);
}

class AuthGateUnauthenticated extends AuthGateState {
  final Failure? failure;
  @override
  List get props => [failure];
  const AuthGateUnauthenticated([this.failure]);
}
