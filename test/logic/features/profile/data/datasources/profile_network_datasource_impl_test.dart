import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/logic/features/profile/data/mappers/profile_mapper.dart';

import '../../../../../shared/helpers/base_tests.dart';
import '../../../../../shared/helpers/helpers.dart';
import '../../shared.dart';

class MockProfileMapper extends Mock implements ProfileMapper {}

class MockAuthenticatedAPIFacade extends Mock implements AuthenticatedAPIFacade {}

void main() {
  late ProfileNetworkDataSourceImpl sut;
  late MockProfileMapper mockProfileMapper;
  late MockAuthenticatedAPIFacade mockApiFacade;

  setUpAll(() => registerFallbackValue(const EndpointQuery("")));
  setUp(() {
    mockProfileMapper = MockProfileMapper();
    mockApiFacade = MockAuthenticatedAPIFacade();
    sut = ProfileNetworkDataSourceImpl(mockProfileMapper, mockApiFacade);
  });

  final tProfile = createTestProfile();
  group('getFollows', () {
    test(
      "should call api with proper args and return the result if the call is successful",
      () async {
        // arrange
        final tFollows = [createTestProfile(), createTestProfile()];
        final tFollow1Json = {"x": "y"};
        final tFollow2Json = {"f": "e"};
        final tResponseBody = {
          'profiles': [tFollow1Json, tFollow2Json]
        };
        final tResponse = http.Response(json.encode(tResponseBody), 200);
        when(() => mockApiFacade.get(any())).thenAnswer((_) async => tResponse);
        when(() => mockProfileMapper.fromJson(tFollow1Json)).thenReturn(tFollows[0]);
        when(() => mockProfileMapper.fromJson(tFollow2Json)).thenReturn(tFollows[1]);
        // act
        final result = await sut.getFollows(tProfile);
        // assert
        expect(result, tFollows);
        verify(() => mockApiFacade.get(getFollowsEndpoint(tProfile.id)));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any())),
      () => sut.getFollows(tProfile),
    );
  });

  group('getMyProfile', () {
    test(
      "should call api and return parsed result if the call is successful",
      () async {
        // arrange
        final tJson = {"asdf": "dfa"};
        when(() => mockApiFacade.get(any())).thenAnswer((_) async => http.Response(json.encode(tJson), 200));
        when(() => mockProfileMapper.fromJson(tJson)).thenReturn(tProfile);
        // act
        final result = await sut.getMyProfile();
        // assert
        expect(result, tProfile);
        verify(() => mockApiFacade.get(getMyProfileEndpoint()));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any())),
      () => sut.getMyProfile(),
    );
  });

  group('getProfile', () {
    final tId = randomString();
    test("should call api and return parsed result if the call is successful", () async {
      // arrange
      final tJson = {"asdf": "dfasf"};
      when(() => mockApiFacade.get(any())).thenAnswer((_) async => http.Response(json.encode(tJson), 200));
      when(() => mockProfileMapper.fromJson(tJson)).thenReturn(tProfile);
      // act
      final result = await sut.getProfile(tId);
      // assert
      expect(result, tProfile);
      verify(() => mockApiFacade.get(getProfileEndpoint(tId)));
      verifyNoMoreInteractions(mockApiFacade);
    });
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.get(any())),
      () => sut.getProfile(tId),
    );
  });

  group('updateProfile', () {
    final tProfileUpdate = createTestProfileUpdate();
    final tJson = {"asdf": "jdfklasd;f"};

    test(
      "should call api and return the result if it was successful",
      () async {
        // arrange
        when(() => mockApiFacade.put(any(), any())).thenAnswer((_) async => http.Response(json.encode(tJson), 200));
        when(() => mockProfileMapper.fromJson(tJson)).thenReturn(tProfile);
        // act
        final result = await sut.updateProfile(tProfileUpdate);
        // assert
        expect(result, tProfile);
        final expectedRequestData = {'about': tProfileUpdate.newAbout!};
        verify(() => mockApiFacade.put(getMyProfileEndpoint(), expectedRequestData));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.put(any(), any())),
      () => sut.updateProfile(tProfileUpdate),
    );
  });

  group("updateAvatar", () {
    final newAvatar = createTestFile();
    final newUrl = randomString();
    final response = json.encode({'avatar_url': newUrl});
    test("should call api and return the result if it was successful", () async {
      // arrange
      when(() => mockApiFacade.sendFiles(any(), any(), any(), any()))
          .thenAnswer((_) async => http.Response(response, 200));
      // act
      final result = await sut.updateAvatar(newAvatar);
      // assert
      expect(result, newUrl);
      verify(() => mockApiFacade.sendFiles("PUT", updateAvatarEndpoint(), {"avatar": newAvatar}, {}));
      verifyNoMoreInteractions(mockApiFacade);
    });
    baseNetworkDataSourceExceptionTests(
        () => when(() => mockApiFacade.sendFiles(any(), any(), any(), any())), () => sut.updateAvatar(newAvatar));
  });

  group('toggleFollow', () {
    test(
      "should call api and return the result if it was successful",
      () async {
        // arrange
        when(() => mockApiFacade.post(any(), any())).thenAnswer((_) async => http.Response("", 200));
        // act
        await sut.toggleFollow(tProfile);
        // assert
        verify(() => mockApiFacade.post(toggleFollowEndpoint(tProfile.id), {}));
        verifyNoMoreInteractions(mockApiFacade);
      },
    );
    baseNetworkDataSourceExceptionTests(
      () => when(() => mockApiFacade.post(any(), any())),
      () => sut.toggleFollow(tProfile),
    );
  });
}
