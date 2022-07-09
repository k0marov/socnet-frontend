import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';

import '../../../../core/error/failures.dart';

typedef PostCreationFailureHandler = PostCreationState Function(PostCreationState, Failure);

PostCreationState postCreationFailureHandlerImpl(PostCreationState state, Failure failure) {
  final clientErrorCode = failure is NetworkFailure ? failure.exception.clientError?.detailCode : null;
  if (clientErrorCode == emptyText.code) {
    return state.withText(state.text.withFailure(emptyText));
  } else if (clientErrorCode == textTooLong.code) {
    return state.withText(state.text.withFailure(textTooLong));
  }
  return state.withFailure(failure);
}
