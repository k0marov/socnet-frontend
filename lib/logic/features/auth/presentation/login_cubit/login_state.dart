part of 'login_cubit.dart';

class LoginState extends Equatable {
  final FieldValue username;
  final FieldValue password;
  bool get canBeSubmitted => username.value.isNotEmpty && password.value.isNotEmpty;
  final Failure? failure;
  @override
  List get props => [username, password, failure];
  const LoginState([this.username = const FieldValue(), this.password = const FieldValue(), this.failure]);

  LoginState withUsername(FieldValue newUsername) => LoginState(newUsername, password, failure);
  LoginState withPassword(FieldValue newPassword) => LoginState(username, newPassword, failure);
  LoginState withFailure(Failure newFailure) => LoginState(username, password, newFailure);
  LoginState withoutFailures() => LoginState(username.withoutFailure(), password.withoutFailure(), null);
}
