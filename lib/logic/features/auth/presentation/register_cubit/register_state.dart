part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final FieldValue curUsername;
  final FieldValue curPass;
  final FieldValue curPassRepeat;
  final PassStrength curPassStrength;
  bool get canBeSubmitted =>
      curUsername.value.isNotEmpty &&
      curPass.value.isNotEmpty &&
      curPassRepeat.value.isNotEmpty &&
      curPassStrength != PassStrength.weak;

  final Failure? curFailure;

  @override
  List get props => [curUsername, curPass, curPassRepeat, curPassStrength, curFailure];

  const RegisterState(
      [this.curUsername = const FieldValue(),
      this.curPass = const FieldValue(),
      this.curPassRepeat = const FieldValue(),
      this.curPassStrength = PassStrength.weak,
      this.curFailure]);

  RegisterState withUsername(FieldValue username) =>
      RegisterState(username, curPass, curPassRepeat, curPassStrength, curFailure);
  RegisterState withPass(FieldValue pass) =>
      RegisterState(curUsername, pass, curPassRepeat, curPassStrength, curFailure);
  RegisterState withPassRepeat(FieldValue passRepeat) =>
      RegisterState(curUsername, curPass, passRepeat, curPassStrength, curFailure);
  RegisterState withPassStrength(PassStrength passStrength) =>
      RegisterState(curUsername, curPass, curPassRepeat, passStrength, curFailure);
  RegisterState withFailure(Failure failure) =>
      RegisterState(curUsername, curPass, curPassRepeat, curPassStrength, failure);
}
