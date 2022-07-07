import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/failure_handler.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _login;
  final LoginFailureHandler _handleFailure;
  final AuthGateBloc _authGate;
  LoginCubit(this._handleFailure, this._login, this._authGate) : super(const LoginState());
  void usernameChanged(String username) => emit(state.withUsername(state.curUsername.withValue(username)));
  void passwordChanged(String pass) => emit(state.withPassword(state.curPassword.withValue(pass)));
  Future<void> loginPressed() async {
    final result = await _login(LoginParams(username: state.curUsername.value, password: state.curPassword.value));
    result.fold(
      (failure) => emit(_handleFailure(state, failure)),
      (success) => _authGate.add(AuthStateUpdateRequested()),
    );
  }
}
