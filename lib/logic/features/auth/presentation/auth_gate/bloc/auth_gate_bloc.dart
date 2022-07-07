import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase.dart';
import '../../../domain/usecases/get_auth_token_usecase.dart';

part 'auth_gate_event.dart';
part 'auth_gate_state.dart';

class AuthGateBloc extends Bloc<AuthGateEvent, AuthGateState> {
  final GetAuthTokenUseCase _getAuthToken;
  final LogoutUsecase _logout;
  AuthGateBloc(
    this._getAuthToken,
    this._logout,
  ) : super(AuthGateInitial()) {
    on<AuthGateEvent>((event, emit) async {
      if (event is LoggedOut && state is AuthGateAuthenticated) {
        final result = await _logout(NoParams());
        result.fold(
          (failure) => emit(AuthGateAuthenticated(failure)),
          (success) {
            emit(const AuthGateUnauthenticated());
          },
        );
      }
      if (event is AuthStateUpdateRequested) {
        final tokenFailureEither = await _getAuthToken(NoParams());
        tokenFailureEither.fold(
          (failure) {
            emit(AuthGateUnauthenticated(failure));
          },
          (token) {
            emit(const AuthGateAuthenticated());
          },
        );
      }
    });
  }
}
