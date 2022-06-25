import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/feed/data/datasources/feed_network_datasource.dart';
import 'package:socnet/features/feed/data/mappers/feed_posts_mapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../core/helpers/base_tests.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../post/post_helpers.dart';

class MockAuthenticatedAPIFacade extends Mock
    implements AuthenticatedAPIFacade {}

void main() {
  late FeedNetworkDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockAPIFacade;

  setUp(() {
    mockAPIFacade = MockAuthenticatedAPIFacade();
    sut = FeedNetworkDataSourceImpl(mockAPIFacade);
  });

  group('getNextPosts', () {
    final tAmount = randomInt();
    Future<FeedPostsMapper> act() => sut.getNextPosts(tAmount);
    Future<http.Response> apiCall() =>
        mockAPIFacade.get("feed/", {'amount': tAmount});
    test(
      "should call api and return parsed result if response status code = 200",
      () async {
        // arrange
        final tPosts = [createTestPost(), createTestPost(), createTestPost()];
        final tMapper = FeedPostsMapper(tPosts);
        final tJson = tMapper.toJson();
        when(apiCall).thenAnswer(
          (_) async => http.Response(
            json.encode(tJson),
            200,
          ),
        );
        // act
        final result = await act();
        // assert
        expect(result, tMapper);
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
