import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_auth_token_usecase.dart';

part 'auth_gate_state.dart';

class AuthGateCubit extends Cubit<AuthState> {
  final GetAuthTokenUseCase _getAuthToken;
  final LogoutUsecase _logout;
  AuthGateCubit(
    this._getAuthToken,
    this._logout,
  ) : super(const AuthState());

  Future<void> logout() async {
    final result = await _logout(NoParams());
    result.fold(
      (failure) => emit(state.withFailure(failure)),
      (success) => emit(state.withoutFailure().withAuthenticated(false)),
    );
  }

  Future<void> refreshState() async {
    final result = await _getAuthToken(NoParams());
    result.fold(
      (failure) => emit(
        failure is NoTokenFailure
            ? state.withoutFailure().withAuthenticated(false)
            : state.withAuthenticated(false).withFailure(failure),
      ),
      (success) => emit(state.withoutFailure().withAuthenticated(true)),
    );
  }
}
