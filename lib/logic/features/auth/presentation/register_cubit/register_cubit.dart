import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/core/field_value.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/failure_handler.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final PassStrengthGetter _getStrength;
  final RegisterUseCase _register;
  final RegisterFailureHandler _handleFailure;

  RegisterCubit(this._getStrength, this._register, this._handleFailure) : super(RegisterState());

  void usernameChanged(String username) => emit(state.withUsername(state.username.withValue(username)));

  void passRepeatChanged(String passRepeat) => emit(state.withPassRepeat(state.passRepeat.withValue(passRepeat)));

  void passChanged(String pass) => emit(
        state.withPass(state.pass.withValue(pass)).withPassStrength(_getStrength(pass)),
      );

  Future<void> registerPressed() async {
    if (!state.canBeSubmitted) return;
    if (state.pass.value != state.passRepeat.value) {
      emit(state.withoutFailures().withPassRepeat(state.passRepeat.withFailure(passwordsDontMatch)));
      return;
    }
    final result = await _register(RegisterParams(username: state.username.value, password: state.pass.value));
    result.fold(
      (failure) => emit(_handleFailure(state.withoutFailures(), failure)),
      (success) => emit(state.withoutFailures()),
    );
  }
}
