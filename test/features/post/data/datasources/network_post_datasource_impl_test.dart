import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/core/authenticated_api_facade.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/features/posts/data/models/post_model.dart';
import 'package:socnet/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import '../../../../core/helpers/base_tests.dart';
import '../../../profile/shared.dart';
import '../../post_helpers.dart';

class MockAuthenticatedAPIFacade extends Mock implements AuthenticatedAPIFacade {}

void main() {
  late NetworkPostDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockApiFacade;

  setUp(() {
    mockApiFacade = MockAuthenticatedAPIFacade();
    sut = NetworkPostDataSourceImpl(mockApiFacade);
  });

  group('createPost', () {
    final tNewPost = NewPostValue(
      images: [fileFixture('avatar.png'), fileFixture('avatar.png')],
      text: 'Some test post',
    );
    final tPost = PostModel(createTestPost());
    test(
      "should call api and return the result if response status code = 200",
      () async {
        // arrange
        when(() => mockApiFacade.sendFiles(any(), any(), any(), any()))
            .thenAnswer((_) async => http.Response(json.encode(tPost.toJson()), 200));
        // act
        final result = await sut.createPost(tNewPost);
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
    final tPostModel = PostModel(createTestPost());
    test("should call api and return void if status code = 200", () async {
      // arrange
      when(() => mockApiFacade.delete(any())).thenAnswer((_) async => http.Response("", 200));
      // act
      await sut.deletePost(tPostModel);
      // assert
      verify(() => mockApiFacade.delete(deletePostEndpoint(tPostModel.toEntity().id)));
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
        final tPosts = [PostModel(createTestPost()), PostModel(createTestPost())];
        final tPostsJson = {'posts': tPosts.map((post) => post.toJson()).toList()};
        final tResponseBody = json.encode(tPostsJson);
        when(() => mockApiFacade.get(any(), any())).thenAnswer((_) async => http.Response(tResponseBody, 200));
        // act
        final result = await sut.getProfilePosts(tProfile);
        // assert
        expect(listEquals(result, tPosts), true);
        verify(() => mockApiFacade.get(getProfilePostsEndpoint(tProfile.toEntity().id), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any(), any())),
      () => sut.getProfilePosts(tProfile),
    );
  });

  group('toggleLike', () {
    final tPost = PostModel(createTestPost());
    test(
      "should call api and return void if status code = 200",
      () async {
        // arrange
        when(() => mockApiFacade.post(any(), any())).thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.toggleLike(tPost);
        // assert
        verify(() => mockApiFacade.post(toggleLikeOnPostEndpoint(tPost.toEntity().id), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.post(any(), any())),
      () => sut.toggleLike(tPost),
    );
  });
}
