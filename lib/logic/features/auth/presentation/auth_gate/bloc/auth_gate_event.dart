part of 'auth_gate_bloc.dart';

abstract class AuthGateEvent extends Equatable {
  const AuthGateEvent();

  @override
  List get props => [];
}

class AuthStateUpdateRequested extends AuthGateEvent {}

class LoggedOut extends AuthGateEvent {}
