import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/failure_handler.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _login;
  final LoginFailureHandler _handleFailure;
  LoginCubit(this._login, this._handleFailure) : super(const LoginState());
  void usernameChanged(String username) => emit(state.withUsername(state.username.withValue(username)));
  void passwordChanged(String pass) => emit(state.withPassword(state.password.withValue(pass)));
  Future<void> loginPressed() async {
    if (!state.canBeSubmitted) return;
    final result = await _login(state.username.value, state.password.value);
    result.fold(
      (failure) => emit(_handleFailure(state.withoutFailures(), failure)),
      (success) => emit(state.withoutFailures()),
    );
  }
}
