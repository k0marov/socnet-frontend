import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/logic/features/comments/data/models/comment_model.dart';
import 'package:socnet/logic/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:socnet/logic/features/posts/data/models/post_model.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../posts/post_helpers.dart';
import '../../comment_helpers.dart';

class MockCommentNetworkDataSource extends Mock implements CommentNetworkDataSource {}

void main() {
  late CommentRepositoryImpl sut;
  late MockCommentNetworkDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockCommentNetworkDataSource();
    sut = CommentRepositoryImpl(mockDataSource);
  });

  group('addPostComment', () {
    final tPost = createTestPost();
    final tNewComment = createTestNewComment();
    final tCreatedComment = createTestComment();
    baseRepositoryTests(
      () => sut.addPostComment(tPost, tNewComment),
      () => mockDataSource.addPostComment(PostModel(tPost), tNewComment),
      CommentModel(tCreatedComment),
      (result) => result == tCreatedComment,
      () => mockDataSource,
    );
  });
  group('deleteComment', () {
    final tComment = createTestComment();
    baseRepositoryTests(
      () => sut.deleteComment(tComment),
      () => mockDataSource.deleteComment(CommentModel(tComment)),
      null,
      (result) => result == null,
      () => mockDataSource,
    );
  });

  group('getPostComments', () {
    final tPost = createTestPost();
    final tComments = [createTestComment(), createTestComment()];
    final tCommentModels = [
      CommentModel(tComments[0]),
      CommentModel(tComments[1]),
    ];
    baseRepositoryTests(
      () => sut.getPostComments(tPost),
      () => mockDataSource.getPostComments(PostModel(tPost)),
      tCommentModels,
      (result) => listEquals(result, tComments),
      () => mockDataSource,
    );
  });

  group('toggleLikeOnComment', () {
    final tComment = createTestComment();
    final tExpectedComment = tComment.withLikeToggled();
    baseRepositoryTests(
      () => sut.toggleLikeOnComment(tComment),
      () => mockDataSource.toggleLikeOnComment(CommentModel(tComment)),
      null,
      (result) => result == tExpectedComment,
      () => mockDataSource,
    );
  });
}
