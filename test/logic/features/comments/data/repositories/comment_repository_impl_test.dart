import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/logic/features/comments/data/repositories/comment_repository_impl.dart';

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
      () => mockDataSource.addPostComment(tPost, tNewComment),
      tCreatedComment,
      (result) => result == tCreatedComment,
      () => mockDataSource,
    );
  });
  group('deleteComment', () {
    final tComment = createTestComment();
    baseRepositoryTests(
      () => sut.deleteComment(tComment),
      () => mockDataSource.deleteComment(tComment),
      null,
      (result) => result == null,
      () => mockDataSource,
    );
  });

  group('getPostComments', () {
    final tPost = createTestPost();
    final tComments = [createTestComment(), createTestComment()];
    baseRepositoryTests(
      () => sut.getPostComments(tPost),
      () => mockDataSource.getPostComments(tPost),
      tComments,
      (result) => listEquals(result, tComments),
      () => mockDataSource,
    );
  });

  group('toggleLikeOnComment', () {
    final tComment = createTestComment();
    final tExpectedComment = tComment.withLikeToggled();
    baseRepositoryTests(
      () => sut.toggleLikeOnComment(tComment),
      () => mockDataSource.toggleLikeOnComment(tComment),
      null,
      (result) => result == tExpectedComment,
      () => mockDataSource,
    );
  });
}
