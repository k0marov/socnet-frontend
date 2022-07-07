import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/usecases/add_comment.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../post/post_helpers.dart';
import '../../comment_helpers.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late AddComment sut;
  late MockCommentRepository mockRepository;

  setUp(() {
    mockRepository = MockCommentRepository();
    sut = AddComment(mockRepository);
  });

  final tPost = createTestPost();
  final tNewComment = createTestNewComment();
  test(
    "should forward the call to the repository",
    () => baseUseCaseTest(
      () => sut(AddCommentParams(newComment: tNewComment, post: tPost)),
      () => mockRepository.addPostComment(tPost, tNewComment),
      mockRepository,
    ),
  );
}
