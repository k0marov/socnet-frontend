part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String curUsername;
  final String curPassword;
  final Failure? failure;
  @override
  List get props => [curUsername, curPassword, failure];
  const LoginState(this.curUsername, this.curPassword, [this.failure]);

  LoginState withUsername(String username) => LoginState(username, curPassword, failure);
  LoginState withPassword(String password) => LoginState(curUsername, password, failure);
  LoginState withFailure(Failure newFailure) => LoginState(curUsername, curPassword, newFailure);
}
