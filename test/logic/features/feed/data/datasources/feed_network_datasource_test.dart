import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/logic/features/posts/data/models/post_model.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import '../../../post/post_helpers.dart';

class MockAuthenticatedAPIFacade extends Mock implements AuthenticatedAPIFacade {}

void main() {
  late FeedNetworkDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockAPIFacade;

  setUp(() {
    mockAPIFacade = MockAuthenticatedAPIFacade();
    sut = FeedNetworkDataSourceImpl(mockAPIFacade);
  });

  group('getNextPosts', () {
    final tAmount = randomInt();
    Future<List<PostModel>> act() => sut.getNextPosts(tAmount);
    Future<http.Response> apiCall() => mockAPIFacade.get(feedEndpoint(tAmount));
    test(
      "should call api and return parsed result if response status code = 200",
      () async {
        // arrange
        final tPosts = [createTestPost(), createTestPost(), createTestPost()].map((post) => PostModel(post));
        final tJson = {
          "posts": tPosts.map((post) => post.toJson()).toList(),
        };
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