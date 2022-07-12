import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/logic/features/comments/data/mappers/comment_mapper.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../posts/post_helpers.dart';
import '../../comment_helpers.dart';

class MockCommentMapper extends Mock implements CommentMapper {}

class MockAuthenticatedAPIFacade extends Mock implements AuthenticatedAPIFacade {}

void main() {
  late CommentNetworkDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockAPIFacade;
  late MockCommentMapper mockCommentMapper;

  setUpAll(() => registerFallbackValue(const EndpointQuery("")));

  setUp(() {
    mockAPIFacade = MockAuthenticatedAPIFacade();
    mockCommentMapper = MockCommentMapper();
    sut = CommentNetworkDataSourceImpl(mockCommentMapper, mockAPIFacade);
  });

  group('deleteComment', () {
    final tComment = createTestComment();
    test(
      "should call api and return void if result status code = 200",
      () async {
        // arrange
        when(() => mockAPIFacade.delete(any())).thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.deleteComment(tComment);
        // assert
        verify(() => mockAPIFacade.delete(deleteCommentEndpoint(tComment.id)));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.delete(any())),
      () => sut.deleteComment(tComment),
    );
  });

  group('addPostComment', () {
    final tPost = createTestPost();
    final tNewComment = createTestNewComment();
    final tCreatedComment = createTestComment();
    final tCreatedJson = {"y": "x"};
    test(
      "should call api and return the parsed result if result status code = 200",
      () async {
        // arrange
        when(() => mockAPIFacade.post(any(), any()))
            .thenAnswer((_) async => http.Response(json.encode(tCreatedJson), 200));
        when(() => mockCommentMapper.fromJson(tCreatedJson)).thenReturn(tCreatedComment);
        // act
        final result = await sut.addPostComment(tPost, tNewComment);
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
      () => sut.addPostComment(tPost, tNewComment),
    );
  });

  group('getPostComments', () {
    final tPost = createTestPost();
    final tComments = [createTestComment(), createTestComment()];
    final tCommentsJson = {
      'comments': [
        {"x": "y"},
        {"y": "z"}
      ]
    };
    test(
      "should call api and return the parsed result if result status code = 200",
      () async {
        // arrange
        when(() => mockAPIFacade.get(any())).thenAnswer((_) async => http.Response(json.encode(tCommentsJson), 200));
        when(() => mockCommentMapper.fromJson(tCommentsJson['comments']![0])).thenReturn(tComments[0]);
        when(() => mockCommentMapper.fromJson(tCommentsJson['comments']![1])).thenReturn(tComments[1]);
        // act
        final result = await sut.getPostComments(tPost);
        // assert
        expect(result, tComments);
        verify(() => mockAPIFacade.get(getPostCommentsEndpoint(tPost.id)));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.get(any())),
      () => sut.getPostComments(tPost),
    );
  });

  group('toggleLikeOnComment', () {
    final tComment = createTestComment();
    test(
      "should call api and return void if result status code is not 200",
      () async {
        // arrange
        when(() => mockAPIFacade.post(any(), any())).thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.toggleLikeOnComment(tComment);
        // assert
        verify(() => mockAPIFacade.post(toggleLikeOnCommentEndpoint(tComment.id), {}));
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockAPIFacade.post(any(), any())),
      () => sut.toggleLikeOnComment(tComment),
    );
  });
}
