part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final FieldValue username;
  final FieldValue pass;
  final FieldValue passRepeat;
  final PassStrength passStrength;
  bool get canBeSubmitted =>
      username.value.isNotEmpty &&
      pass.value.isNotEmpty &&
      passRepeat.value.isNotEmpty &&
      passStrength != PassStrength.weak;

  final Failure? failure;

  @override
  List get props => [username, pass, passRepeat, passStrength, failure];

  const RegisterState(
      [this.username = const FieldValue(),
      this.pass = const FieldValue(),
      this.passRepeat = const FieldValue(),
      this.passStrength = PassStrength.weak,
      this.failure]);

  RegisterState withUsername(FieldValue newUsername) =>
      RegisterState(newUsername, pass, passRepeat, passStrength, failure);
  RegisterState withPass(FieldValue newPass) => RegisterState(username, newPass, passRepeat, passStrength, failure);
  RegisterState withPassRepeat(FieldValue newPassRepeat) =>
      RegisterState(username, pass, newPassRepeat, passStrength, failure);
  RegisterState withPassStrength(PassStrength newStrength) =>
      RegisterState(username, pass, passRepeat, newStrength, failure);
  RegisterState withFailure(Failure newFailure) => RegisterState(username, pass, passRepeat, passStrength, newFailure);
}
