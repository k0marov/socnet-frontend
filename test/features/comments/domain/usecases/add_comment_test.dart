import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/features/comments/domain/usecases/add_comment.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/helpers/base_tests.dart';
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
