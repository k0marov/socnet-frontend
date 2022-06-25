import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/const/endpoints.dart';
import 'package:socnet/core/facades/authenticated_api_facade.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:socnet/features/profile/data/models/profile_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/helpers/base_tests.dart';
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

  final tProfile = ProfileModel(createTestProfile());
  group('getFollows', () {
    test(
      "should call api with proper args and return the result if the call is successful",
      () async {
        // arrange
        final tFollows = [createTestProfile(), createTestProfile()];
        final tFollowsModels = tFollows.map((profile) => ProfileModel(profile)).toList();
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
            .get(getFollowsEndpoint(tProfile.toEntity().id), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any(), any())),
      () => sut.getFollows(tProfile),
    );
  });

  group('getMyProfile', () {
    test(
      "should call api and return parsed result if the call is successful",
      () async {
        // arrange
        final responseBody = json.encode(tProfile.toJson());
        when(() => mockApiFacade.get(any(), any()))
            .thenAnswer((_) async => http.Response(responseBody, 200));
        // act
        final result = await sut.getMyProfile();
        // assert
        expect(result, tProfile);
        verify(() => mockApiFacade.get(getMyProfileEndpoint(), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any(), any())),
      () => sut.getMyProfile(),
    );
  });

  group('updateProfile', () {
    final tProfileUpdate = createTestProfileUpdate();
    final tProfileJson = json.encode(tProfile.toJson());

    test(
      "should call api and return the result if it was successful",
      () async {
        // arrange
        when(() => mockApiFacade.sendFiles(any(), any(), any(), any()))
            .thenAnswer((_) async => http.Response(tProfileJson, 200));
        // act
        final result = await sut.updateProfile(tProfileUpdate);
        // assert
        expect(result, tProfile);
        final expectedRequestData = {'about': tProfileUpdate.newAbout!};
        final files = {'avatar': tProfileUpdate.newAvatar!};
        verify(() => mockApiFacade.sendFiles(
            "PUT", getMyProfileEndpoint(), files, expectedRequestData));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
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
            .post(toggleFollowEndpoint(tProfile.toEntity().id), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.post(any(), any())),
      () => sut.toggleFollow(tProfile),
    );
  });
}
