import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/exceptions.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:socnet/features/profile/data/models/my_profile_model.dart';
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:socnet/features/profile/domain/entities/my_profile.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/helpers/helpers.dart';
import '../../shared.dart';

class MockAuthenticatedAPIFacade extends Mock
    implements AuthenticatedAPIFacade {}

void main() {
  late ProfileNetworkDataSourceImpl sut;
  late MockAuthenticatedAPIFacade mockApiFacade;

  setUp(() {
    mockApiFacade = MockAuthenticatedAPIFacade();
    sut = ProfileNetworkDataSourceImpl(mockApiFacade);
  });

  final tExceptionDetail = randomString();
  final tExceptionBody = json.encode({
    'detail': tExceptionDetail,
  });

  void _baseExceptionTests(When Function() whenApiCall, Function sutCall) {
    test(
      "should rethrow NoTokenException",
      () async {
        // arrange
        whenApiCall().thenThrow(NoTokenException());
        // assert
        expect(sutCall, throwsA(isA<NoTokenException>()));
      },
    );
    test(
      "should throw NetworkException if the response status code is not 200",
      () async {
        // arrange
        whenApiCall()
            .thenAnswer((_) async => http.Response(tExceptionBody, 4242));
        // assert
        final expectedException = NetworkException(4242, tExceptionDetail);
        expect(sutCall, throwsA(equals(expectedException)));
      },
    );
    test(
      "should throw NetworkException.unknown() if something throws",
      () async {
        // arrange
        whenApiCall().thenThrow(Exception());
        // assert
        expect(sutCall, throwsA(equals(const NetworkException.unknown())));
      },
    );
  }

  final tProfile = ProfileModel(createTestProfile());
  final tMyProfile = MyProfileModel(MyProfile(
    profile: tProfile.toEntity(),
    follows: [createTestProfile(), createTestProfile()],
  ));
  group('getFollows', () {
    test(
      "should call api with proper args and return the result if the call is successful",
      () async {
        // arrange
        final tFollows = [createTestProfile(), createTestProfile()];
        final tFollowsModels =
            tFollows.map((profile) => ProfileModel(profile)).toList();
        final tResponseBody = {
          'profiles': tFollowsModels.map((model) => model.toJson()).toList()
        };
        final tResponse = http.Response(json.encode(tResponseBody), 200);
        when(() => mockApiFacade.get(any(), any()))
            .thenAnswer((_) async => tResponse);
        // act
        final result = await sut.getFollows(tProfile);
        // assert
        expect(result, tFollowsModels);
        verify(() => mockApiFacade
            .get('profiles/' + tProfile.toEntity().id + '/follows/', {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    _baseExceptionTests(
      () => when(() => mockApiFacade.get(any(), any())),
      () => sut.getFollows(tProfile),
    );
  });

  group('getMyProfile', () {
    test(
      "should call api and return parsed result if the call is successful",
      () async {
        // arrange
        final responseBody = json.encode(tMyProfile.toJson());
        when(() => mockApiFacade.get(any(), any()))
            .thenAnswer((_) async => http.Response(responseBody, 200));
        // act
        final result = await sut.getMyProfile();
        // assert
        expect(result, tMyProfile);
        verify(() => mockApiFacade.get('profiles/me/', {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    _baseExceptionTests(
      () => when(() => mockApiFacade.get(any(), any())),
      () => sut.getMyProfile(),
    );
  });

  group('updateProfile', () {
    final tProfileUpdate = createTestProfileUpdate();
    final tProfileJson = json.encode(tMyProfile.toJson());

    test(
      "should call api and return the result if it was successful",
      () async {
        // arrange
        when(() => mockApiFacade.sendFiles(any(), any(), any(), any()))
            .thenAnswer((_) async => http.Response(tProfileJson, 200));
        // act
        final result = await sut.updateProfile(tProfileUpdate);
        // assert
        expect(result, tMyProfile);
        final expectedRequestData = {'about': tProfileUpdate.newAbout};
        final files = {'avatar': tProfileUpdate.newAvatar!};
        verify(() => mockApiFacade.sendFiles(
            "PUT", "profiles/me/", files, expectedRequestData));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    _baseExceptionTests(
      () => when(() => mockApiFacade.sendFiles(any(), any(), any(), any())),
      () => sut.updateProfile(tProfileUpdate),
    );
  });

  group('toggleFollow', () {
    test(
      "should call api and return the result if it was successful",
      () async {
        // arrange
        when(() => mockApiFacade.post(any(), any()))
            .thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.toggleFollow(tProfile);
        // assert
        verify(() => mockApiFacade
            .post("profiles/${tProfile.toEntity().id}/toggle-follow/", {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    _baseExceptionTests(
      () => when(() => mockApiFacade.post(any(), any())),
      () => sut.toggleFollow(tProfile),
    );
  });
}
