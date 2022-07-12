import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/logic/features/posts/data/mappers/post_mapper.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/logic/features/profile/data/models/profile_model.dart';

import '../../../../../shared/fixtures/fixture_reader.dart';
import '../../../../../shared/helpers/base_tests.dart';
import '../../../profile/shared.dart';
import '../../post_helpers.dart';

class MockPostMapper extends Mock implements PostMapper {}

class MockAuthenticatedAPIFacade extends Mock implements AuthenticatedAPIFacade {}

void main() {
  late NetworkPostDataSourceImpl sut;
  late MockPostMapper mockPostMapper;
  late MockAuthenticatedAPIFacade mockApiFacade;

  setUpAll(() => registerFallbackValue(const EndpointQuery("")));
  setUp(() {
    mockApiFacade = MockAuthenticatedAPIFacade();
    mockPostMapper = MockPostMapper();
    sut = NetworkPostDataSourceImpl(mockPostMapper, mockApiFacade);
  });

  group('createPost', () {
    final tNewPost = NewPostValue(
      images: [fileFixture('avatar.png'), fileFixture('avatar.png')],
      text: 'Some test post',
    );
    final tPost = createTestPost();
    final tPostJson = {'asdf': "fdsa", "x": "y"};
    test(
      "should call api and return the result if response status code = 200",
      () async {
        // arrange
        when(() => mockApiFacade.sendFiles(any(), any(), any(), any()))
            .thenAnswer((_) async => http.Response(json.encode(tPostJson), 200));
        when(() => mockPostMapper.fromJson(tPostJson)).thenReturn(tPost);
        // act
        await sut.createPost(tNewPost);
        final expectedFiles = {
          "image_1": tNewPost.images[0],
          "image_2": tNewPost.images[1],
        };
        final expectedData = {
          "text": "Some test post",
        };
        verify(
          () => mockApiFacade.sendFiles(
            "POST",
            createPostEndpoint(),
            expectedFiles,
            expectedData,
          ),
        );
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.sendFiles(any(), any(), any(), any())),
      () => sut.createPost(tNewPost),
    );
  });
  group('deletePost', () {
    final tPostModel = createTestPost();
    test("should call api and return void if status code = 200", () async {
      // arrange
      when(() => mockApiFacade.delete(any())).thenAnswer((_) async => http.Response("", 200));
      // act
      await sut.deletePost(tPostModel);
      // assert
      verify(() => mockApiFacade.delete(deletePostEndpoint(tPostModel.id)));
      verifyNoMoreInteractions(mockApiFacade);
    });
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.delete(any())),
      () => sut.deletePost(tPostModel),
    );
  });
  group('getProfilePosts', () {
    final tProfile = ProfileModel(createTestProfile());
    test(
      "should call api and return parsed result if status code = 200",
      () async {
        // arrange
        final tPosts = [createTestPost(), createTestPost()];
        final tPost1Json = {"x": "y"};
        final tPost2Json = {"z": "w"};
        final tPostsJson = {
          'posts': [tPost1Json, tPost2Json]
        };
        when(() => mockApiFacade.get(any())).thenAnswer((_) async => http.Response(json.encode(tPostsJson), 200));
        when(() => mockPostMapper.fromJson(tPost1Json)).thenReturn(tPosts[0]);
        when(() => mockPostMapper.fromJson(tPost2Json)).thenReturn(tPosts[1]);
        // act
        final result = await sut.getProfilePosts(tProfile);
        // assert
        expect(listEquals(result, tPosts), true);
        verify(() => mockApiFacade.get(getProfilePostsEndpoint(tProfile.toEntity().id)));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any())),
      () => sut.getProfilePosts(tProfile),
    );
  });

  group('toggleLike', () {
    final tPost = createTestPost();
    test(
      "should call api and return void if status code = 200",
      () async {
        // arrange
        when(() => mockApiFacade.post(any(), any())).thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.toggleLike(tPost);
        // assert
        verify(() => mockApiFacade.post(toggleLikeOnPostEndpoint(tPost.id), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.post(any(), any())),
      () => sut.toggleLike(tPost),
    );
  });
}
