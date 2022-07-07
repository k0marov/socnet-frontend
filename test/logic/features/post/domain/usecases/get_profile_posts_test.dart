import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/logic/features/posts/domain/usecases/get_profile_posts.dart';

import '../../../profile/shared.dart';
import '../../post_helpers.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late GetProfilePosts sut;

  setUp(() {
    mockPostRepository = MockPostRepository();
    sut = GetProfilePosts(mockPostRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      final tProfile = createTestProfile();
      final tPosts = [createTestPost(), createTestPost()];
      when(() => mockPostRepository.getProfilePosts(tProfile)).thenAnswer((_) async => Right(tPosts));
      // act
      final result = await sut(ProfileParams(profile: tProfile));
      // assert
      result.fold(
        (failure) => throw UnimplementedError(),
        (posts) => expect(identical(posts, tPosts), true),
      );
      verify(() => mockPostRepository.getProfilePosts(tProfile));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
