import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/failure_handler.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/register_usecase.dart';
import '../auth_gate/auth_gate_cubit.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final PassStrengthGetter _getStrength;
  final RegisterUseCase _register;
  final RegisterFailureHandler _handleFailure;
  final AuthGateCubit _authGate;
  RegisterCubit(this._getStrength, this._register, this._handleFailure, this._authGate) : super(RegisterState());
  void usernameChanged(String username) => emit(state.withUsername(state.curUsername.withValue(username)));
  void passRepeatChanged(String passRepeat) => emit(state.withPassRepeat(state.curPassRepeat.withValue(passRepeat)));
  void passChanged(String pass) => emit(
        state.withPass(state.curPass.withValue(pass)).withPassStrength(_getStrength(pass)),
      );

  Future<void> registerPressed() async {
    if (!state.canBeSubmitted) return;
    if (state.curPass.value != state.curPassRepeat.value) {
      emit(state.withPassRepeat(state.curPassRepeat.withFailure(passwordsDontMatch)));
      return;
    }
    final result = await _register(RegisterParams(username: state.curUsername.value, password: state.curPass.value));
    result.fold(
      (failure) => emit(_handleFailure(state, failure)),
      (success) => _authGate.add(AuthStateUpdateRequested()),
    );
  }
}
