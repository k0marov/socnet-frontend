import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/features/comments/domain/usecases/comment_params.dart';
import 'package:socnet/features/comments/domain/usecases/delete_comment.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/helpers/base_tests.dart';
import '../../comment_helpers.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late DeleteComment sut;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    sut = DeleteComment(mockRepository);
  });

  final tComment = createTestComment();
  test(
    "should forward the call to the repository",
    () => baseUseCaseTest(
      () => sut(CommentParams(comment: tComment)),
      () => mockRepository.deleteComment(tComment),
      mockRepository,
    ),
  );
}
