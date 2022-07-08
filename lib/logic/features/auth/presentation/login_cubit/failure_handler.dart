import 'package:socnet/logic/core/error/form_failures.dart';

import '../../../../core/error/failures.dart';
import 'login_cubit.dart';

typedef LoginFailureHandler = LoginState Function(LoginState, Failure);

LoginState loginFailureHandlerImpl(LoginState state, Failure failure) {
  if (failure is NetworkFailure && failure.exception.clientError?.detailCode == invalidCredentials.code) {
    return state.withUsername(state.curUsername.withFailure(invalidCredentials));
  }
  return state.withFailure(failure);
}
