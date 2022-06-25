import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/features/comments/data/models/comment_model.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../core/helpers/base_tests.dart';
import '../../../post/post_helpers.dart';
import '../../comment_helpers.dart';

class MockAuthenticatedAPIFacade extends Mock
    implements AuthenticatedAPIFacade {}

void main() {
  late CommentNetworkDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockAPIFacade;

  setUp(() {
    mockAPIFacade = MockAuthenticatedAPIFacade();
    sut = CommentNetworkDataSourceImpl(mockAPIFacade);
  });

  group('deleteComment', () {
    final tComment = createTestComment();
    test(
      "should call api and return void if result status code = 200",
      () async {
        // arrange
        when(() => mockAPIFacade.delete(any()))
            .thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.deleteComment(CommentModel(tComment));
        // assert
        verify(() => mockAPIFacade.delete(deleteCommentEndpoint(tComment.id)));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.delete(any())),
      () => sut.deleteComment(CommentModel(tComment)),
    );
  });

  group('addPostComment', () {
    final tPost = createTestPost();
    final tNewComment = createTestNewComment();
    final tCreatedComment = CommentModel(createTestComment());
    final tCreatedJson = tCreatedComment.toJson();
    test(
      "should call api and return the parsed result if result status code = 200",
      () async {
        // arrange
        when(() => mockAPIFacade.post(any(), any())).thenAnswer(
            (_) async => http.Response(json.encode(tCreatedJson), 200));
        // act
        final result = await sut.addPostComment(PostModel(tPost), tNewComment);
        // assert
        expect(result, tCreatedComment);
        verify(() => mockAPIFacade.post(
              addPostCommentEndpoint(tPost.id),
              {'text': tNewComment.text},
            ));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.post(any(), any())),
      () => sut.addPostComment(PostModel(tPost), tNewComment),
    );
  });

  group('getPostComments', () {
    final tPost = createTestPost();
    final tComments = [createTestComment(), createTestComment()];
    final tCommentModels = [
      CommentModel(tComments[0]),
      CommentModel(tComments[1]),
    ];
    final tCommentsJson = {
      'comments': tCommentModels.map((model) => model.toJson()).toList()
    };
    test(
      "should call api and return the parsed result if result status code = 200",
      () async {
        // arrange
        when(() => mockAPIFacade.get(any(), any())).thenAnswer(
            (_) async => http.Response(json.encode(tCommentsJson), 200));
        // act
        final result = await sut.getPostComments(PostModel(tPost));
        // assert
        expect(result, tCommentModels);
        verify(() => mockAPIFacade.get(getPostCommentsEndpoint(tPost.id), {}));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.get(any(), any())),
      () => sut.getPostComments(PostModel(tPost)),
    );
  });

  group('toggleLikeOnComment', () {
    final tComment = createTestComment();
    final tCommentModel = CommentModel(tComment);
    test(
      "should call api and return void if result status code is not 200",
      () async {
        // arrange
        when(() => mockAPIFacade.post(any(), any()))
            .thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.toggleLikeOnComment(tCommentModel);
        // assert
        verify(() =>
            mockAPIFacade.post(toggleLikeOnCommentEndpoint(tComment.id), {}));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.post(any(), any())),
      () => sut.toggleLikeOnComment(tCommentModel),
    );
  });
}
