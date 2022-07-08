part of 'login_cubit.dart';

class LoginState extends Equatable {
  final FieldValue curUsername;
  final FieldValue curPassword;
  bool get canBeSubmitted => curUsername.value.isNotEmpty && curPassword.value.isNotEmpty;
  final Failure? curFailure;
  @override
  List get props => [curUsername, curPassword, curFailure];
  const LoginState([this.curUsername = const FieldValue(), this.curPassword = const FieldValue(), this.curFailure]);

  LoginState withUsername(FieldValue username) => LoginState(username, curPassword, curFailure);
  LoginState withPassword(FieldValue password) => LoginState(curUsername, password, curFailure);
  LoginState withFailure(Failure newFailure) => LoginState(curUsername, curPassword, newFailure);
}
