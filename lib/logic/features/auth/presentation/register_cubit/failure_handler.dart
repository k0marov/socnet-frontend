import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';

import '../../../../core/error/failures.dart';

typedef RegisterFailureHandler = RegisterState Function(RegisterState, Failure);

RegisterState registerFailureHandlerImpl(RegisterState state, Failure failure) {
  final clientError = failure is NetworkFailure ? failure.exception.clientError : null;
  if (clientError?.detailCode == usernameTaken.code) {
    return state.withUsername(state.curUsername.withFailure(usernameTaken));
  } else if (clientError?.detailCode == usernameInvalid.code) {
    return state.withUsername(state.curUsername.withFailure(usernameInvalid));
  }
  return state.withFailure(failure);
}
