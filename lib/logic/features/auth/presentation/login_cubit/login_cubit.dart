import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthGateBloc _authGate;
  final LoginUseCase _login;
  LoginCubit(this._login, this._authGate) : super(const LoginState("", ""));
  void usernameChanged(String newUsername) => emit(state.withUsername(newUsername));
  void passwordChanged(String newPassword) => emit(state.withPassword(newPassword));
  Future<void> loginPressed() async {
    final result = await _login(LoginParams(username: state.curUsername, password: state.curPassword));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => _authGate.add(AuthStateUpdateRequested()),
    );
  }
}
