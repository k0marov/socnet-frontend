import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';

import '../../auth_gate/bloc/auth_gate_bloc.dart';

part 'auth_page_event.dart';
part 'auth_page_state.dart';

// this is used to allow for simple GetIt injection
class AuthPageBlocCreator {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  const AuthPageBlocCreator(this._login, this._register);

  AuthPageBloc create(AuthGateBloc authGateBloc) => AuthPageBloc(
        authGateBloc,
        _login,
        _register,
      );
}

class AuthPageBloc extends Bloc<AuthPageEvent, AuthPageState> {
  final AuthGateBloc _authGateBloc;
  final LoginUseCase _login;
  final RegisterUseCase _register;

  AuthPageBloc(
    this._authGateBloc,
    this._login,
    this._register,
  ) : super(const AuthPageLogin()) {
    on<AuthPageEvent>((event, emit) async {
      if (event is SwitchedToRegistration) {
        emit(const AuthPageRegistration());
      } else if (event is SwitchedToLogin) {
        emit(const AuthPageLogin());
      } else if (event is LoginRequested) {
        emit(const AuthPageLoading());
        final result = await _login(LoginParams(
          username: event.username,
          password: event.password,
        ));
        result.fold((failure) => emit(AuthPageLoginFailure(username: event.username, password: event.password, failure: failure)),
            (token) => _authGateBloc.add(AuthStateUpdateRequested()));
      } else if (event is RegistrationRequested) {
        emit(const AuthPageLoading());
        final result = await _register(RegisterParams(
          username: event.username,
          password: event.password,
        ));
        result.fold(
          (failure) => emit(AuthPageRegistrationFailure(username: event.username, password: event.password, failure: failure)),
          (token) => _authGateBloc.add(AuthStateUpdateRequested()),
        );
        _authGateBloc.add(AuthStateUpdateRequested());
      }
    });
  }
}
