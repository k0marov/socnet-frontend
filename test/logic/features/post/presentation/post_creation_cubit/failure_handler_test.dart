import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/error/exceptions.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/failure_handler.dart';

import '../../../../../shared/helpers/helpers.dart';
import 'post_creation_cubit_test.dart';

void main() {
  final tState = randomPostCreationState();
  test("should just set the failure if failure does not contain a client error", () async {
    final tFailure = randomFailure();
    final gotState = postCreationFailureHandlerImpl(tState, tFailure);
    expect(gotState, tState.withFailure(tFailure));
  });
  test("should set failure on text if failure contains empty-text client error", () async {
    final tFailure = NetworkFailure(NetworkException(400, ClientError(emptyText.code, "blablabla")));
    final gotState = postCreationFailureHandlerImpl(tState, tFailure);
    expect(gotState, tState.withText(tState.text.withFailure(emptyText)));
  });
  test("should set failure on text if failure contains long-text client error", () async {
    final tFailure = NetworkFailure(NetworkException(400, ClientError(textTooLong.code, "blablabla")));
    final gotState = postCreationFailureHandlerImpl(tState, tFailure);
    expect(gotState, tState.withText(tState.text.withFailure(textTooLong)));
  });
}
