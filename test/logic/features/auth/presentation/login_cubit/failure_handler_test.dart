import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/failure_handler.dart';

import '../../../../../shared/helpers/helpers.dart';
import 'login_cubit_test.dart';

void main() {
  final tState = randomLoginState();
  test("should do nothing except for setting the failure if failure does not contain a ClientError", () async {
    // arrange
    const tFailure = NetworkFailure(NetworkException(404, null));
    // act
    final gotState = loginFailureHandlerImpl(tState, tFailure);
    // assert
    expect(gotState, tState.withFailure(tFailure));
  });
  test("should add error to username if failure contains InvalidCredentials client error", () async {
    // arrange
    final tFailure = NetworkFailure(NetworkException(400, ClientError(invalidCredentials.code, randomString())));
    // act
    final gotState = loginFailureHandlerImpl(tState, tFailure);
    // assert
    expect(gotState, tState.withUsername(tState.username.withFailure(invalidCredentials)));
  });
}
