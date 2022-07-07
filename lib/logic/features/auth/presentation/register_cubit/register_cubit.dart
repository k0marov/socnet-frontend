import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/register_usecase.dart';
import '../auth_gate/bloc/auth_gate_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final PassStrengthGetter _getStrength;
  final RegisterUseCase _register;
  final AuthGateBloc _authGate;
  RegisterCubit(this._getStrength, this._register, this._authGate)
      : super(RegisterState());
  void usernameChanged(String username) =>
      emit(state.withUsername(state.curUsername.withValue(username)));
  void passRepeatChanged(String passRepeat) =>
      emit(state.withPassRepeat(state.curPassRepeat.withValue(passRepeat)));
  void passChanged(String pass) => emit(state
      .withPass(state.curPass.withValue(pass))
      .withPassStrength(_getStrength(pass)));

  Future<void> registerPressed() async {
    final result = await _register(RegisterParams(
        username: state.curUsername.value, password: state.curPass.value));
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => _authGate.add(AuthStateUpdateRequested()),
    );
  }
}
