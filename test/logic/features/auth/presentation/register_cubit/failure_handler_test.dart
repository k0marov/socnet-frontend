import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/failure_handler.dart';

import 'register_cubit_test.dart';

void main() {
  final tState = randomRegisterState();
  test("should just return state with failure if failure does not contain a client error", () async {
    // arrange
    const tFailure = NetworkFailure(404, null);
    // act
    final gotState = registerFailureHandlerImpl(tState, tFailure);
    // assert
    expect(gotState, tState.withFailure(tFailure));
  });
  test("username already taken", () async {
    // arrange
    final tFailure = NetworkFailure(400, ClientError(usernameTaken.code, "blablabla"));
    // act
    final gotState = registerFailureHandlerImpl(tState, tFailure);
    // assert
    expect(gotState, tState.withUsername(tState.username.withFailure(usernameTaken)));
  });
  test("username invalid", () async {
    // arrange
    final tFailure = NetworkFailure(400, ClientError(usernameInvalid.code, "blablablah"));
    // act
    final gotState = registerFailureHandlerImpl(tState, tFailure);
    // assert
    expect(gotState, tState.withUsername(tState.username.withFailure(usernameInvalid)));
  });
}
