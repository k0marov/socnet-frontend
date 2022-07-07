part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final String curUsername;
  final String curPass;
  final String curPassRepeat;
  final PassStrength curPassStrength;
  final Failure? curFailure;

  @override
  List get props => [curUsername, curPass, curPassRepeat, curPassStrength, curFailure];

  const RegisterState(
      [this.curUsername = "",
      this.curPass = "",
      this.curPassRepeat = "",
      this.curPassStrength = PassStrength.weak,
      this.curFailure]);

  RegisterState withUsername(String username) =>
      RegisterState(username, curPass, curPassRepeat, curPassStrength, curFailure);
  RegisterState withPass(String pass) => RegisterState(curUsername, pass, curPassRepeat, curPassStrength, curFailure);
  RegisterState withPassRepeat(String passRepeat) =>
      RegisterState(curUsername, curPass, passRepeat, curPassStrength, curFailure);
  RegisterState withPassStrength(PassStrength passStrength) =>
      RegisterState(curUsername, curPass, curPassRepeat, passStrength, curFailure);
  RegisterState withFailure(Failure failure) =>
      RegisterState(curUsername, curPass, curPassRepeat, curPassStrength, failure);
}
