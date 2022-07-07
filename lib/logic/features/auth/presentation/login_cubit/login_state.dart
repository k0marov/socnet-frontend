part of 'login_cubit.dart';

class LoginState extends Equatable {
  final FieldValue curUsername;
  final FieldValue curPassword;
  bool get canBeSubmitted => curUsername.value.isNotEmpty && curPassword.value.isNotEmpty;
  final Failure? failure;
  @override
  List get props => [curUsername, curPassword, failure];
  const LoginState([this.curUsername = const FieldValue(), this.curPassword = const FieldValue(), this.failure]);

  LoginState withUsername(FieldValue username) => LoginState(username, curPassword, failure);
  LoginState withPassword(FieldValue password) => LoginState(curUsername, password, failure);
  LoginState withFailure(Failure newFailure) => LoginState(curUsername, curPassword, newFailure);
}
