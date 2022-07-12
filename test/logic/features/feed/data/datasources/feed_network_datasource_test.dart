import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/logic/features/posts/data/mappers/post_mapper.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import '../../../posts/post_helpers.dart';

class MockPostMapper extends Mock implements PostMapper {}

class MockAuthenticatedAPIFacade extends Mock implements AuthenticatedAPIFacade {}

void main() {
  late MockPostMapper mockPostMapper;
  late FeedNetworkDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockAPIFacade;

  setUp(() {
    mockPostMapper = MockPostMapper();
    mockAPIFacade = MockAuthenticatedAPIFacade();
    sut = FeedNetworkDataSourceImpl(mockPostMapper, mockAPIFacade);
  });

  group('getNextPosts', () {
    final tAmount = randomInt();
    Future<List<Post>> act() => sut.getNextPosts(tAmount);
    Future<http.Response> apiCall() => mockAPIFacade.get(feedEndpoint(tAmount));
    test(
      "should call api and return parsed result if response status code = 200",
      () async {
        // arrange
        final tPosts = [createTestPost(), createTestPost()];
        final tPost1Json = {"asdf": "baf"};
        final tPost2Json = {"dfs": "x"};
        final tJson = {
          "posts": [tPost1Json, tPost2Json],
        };
        when(() => mockPostMapper.fromJson(tPost1Json)).thenReturn(tPosts[0]);
        when(() => mockPostMapper.fromJson(tPost2Json)).thenReturn(tPosts[1]);
        when(apiCall).thenAnswer(
          (_) async => http.Response(
            json.encode(tJson),
            200,
          ),
        );
        // act
        final result = await act();
        // assert
        expect(result, tPosts);
        verify(apiCall);
        verifyNoMoreInteractions(mockAPIFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(apiCall),
      act,
    );
  });
}
