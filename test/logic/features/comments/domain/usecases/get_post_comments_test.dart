import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/comments/domain/repositories/comment_repository.dart';
import 'package:socnet/logic/features/comments/domain/usecases/get_post_comments.dart';
import 'package:socnet/logic/features/posts/domain/usecases/post_params.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../post/post_helpers.dart';

class MockCommentRepository extends Mock implements CommentRepository {}

void main() {
  late GetPostComments sut;
  late MockCommentRepository mockCommentRepository;

  setUp(() {
    mockCommentRepository = MockCommentRepository();
    sut = GetPostComments(mockCommentRepository);
  });

  final tPost = createTestPost();
  test(
    "should forward the call to the repository",
    () => baseUseCaseTest(
      () => sut(PostParams(post: tPost)),
      () => mockCommentRepository.getPostComments(tPost),
      mockCommentRepository,
    ),
  );
}
