import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_token_stream_usecase.dart';

import '../../../../core/usecase.dart';

enum AuthState {
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthGateCubit extends Cubit<AuthState> {
  final GetTokenStreamUseCase _getTokenStream;
  StreamSubscription? _subscription;
  AuthGateCubit(this._getTokenStream) : super(AuthState.loading);

  void renewStream() {
    _subscription?.cancel();
    _subscription = _getTokenStream(NoParams()).listen(
      (event) => event.fold(
        (failure) => emit(AuthState.failure),
        (tokenOpt) => tokenOpt.fold(
          () => emit(AuthState.unauthenticated),
          (token) => emit(AuthState.authenticated),
        ),
      ),
    );
  }
}
