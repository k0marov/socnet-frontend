import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/logic/features/posts/domain/usecases/post_params.dart';
import 'package:socnet/logic/features/posts/domain/usecases/toggle_like.dart';

import '../../post_helpers.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late ToggleLike sut;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    sut = ToggleLike(mockPostRepository);
  });

  test(
    "should forward the call to repository",
    () async {
      // arrange
      final tPost = createTestPost();
      final tLikedPost = createTestPost();
      when(() => mockPostRepository.toggleLike(tPost)).thenAnswer((_) async => Right(tLikedPost));
      // act
      final result = await sut(PostParams(post: tPost));
      // assert
      result.fold(
        (failure) => throw AssertionError(),
        (likedPost) => expect(identical(likedPost, tLikedPost), true),
      );
      verify(() => mockPostRepository.toggleLike(tPost));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
