import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/register_usecase.dart';
import '../auth_gate/bloc/auth_gate_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _register;
  final AuthGateBloc _authGate;
  RegisterCubit(this._register, this._authGate) : super(RegisterState());
  void usernameChanged(String username) {} // => emit(state.withUsername(username));
  void passRepeatChanged(String passRepeat) {} // => emit(state.withPassRepeat(passRepeat));
  void passChanged(String pass) {
    throw UnimplementedError();
  }

  Future<void> registerPressed() async {
    throw UnimplementedError();
  }
}
