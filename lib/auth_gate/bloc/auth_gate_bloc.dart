import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socnet/core/usecases/usecase.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/logout_usecase.dart';

import '../../core/error/failures.dart';
import '../../core/facades/authenticated_api_facade.dart';

part 'auth_gate_event.dart';
part 'auth_gate_state.dart';

class AuthGateBloc extends Bloc<AuthGateEvent, AuthGateState> {
  final GetAuthTokenUseCase _getAuthToken;
  final LogoutUsecase _logout;
  final AuthenticatedAPIFacade _authenticatedAPI;
  AuthGateBloc(
    this._getAuthToken,
    this._logout,
    this._authenticatedAPI,
  ) : super(AuthGateInitial()) {
    on<AuthGateEvent>((event, emit) async {
      if (event is LoggedOut && state is AuthGateAuthenticated) {
        final result = await _logout(NoParams());
        result.fold(
          (failure) => emit(AuthGateAuthenticated(failure)),
          (success) {
            _authenticatedAPI.setToken(null);
            emit(const AuthGateUnauthenticated());
          },
        );
      }
      if (event is AuthStateUpdateRequested) {
        final tokenFailureEither = await _getAuthToken(NoParams());
        tokenFailureEither.fold(
          (failure) {
            _authenticatedAPI.setToken(null);
            emit(AuthGateUnauthenticated(failure));
          },
          (token) {
            _authenticatedAPI.setToken(token);
            emit(const AuthGateAuthenticated());
          },
        );
      }
    });
  }
}
