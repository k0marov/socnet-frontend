import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/core/error/failures.dart';
import 'package:socnet/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/features/posts/domain/usecases/delete_post.dart';
import 'package:socnet/features/posts/domain/usecases/post_params.dart';
import 'package:mocktail/mocktail.dart';

import '../../post_helpers.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late DeletePost sut;

  setUp(() {
    mockPostRepository = MockPostRepository();
    sut = DeletePost(mockPostRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      final tPost = createTestPost();
      const tFailure = NetworkFailure.unknown();
      when(() => mockPostRepository.deletePost(tPost))
          .thenAnswer((_) async => const Left(tFailure));
      // act
      final result = await sut(PostParams(post: tPost));
      // assert
      result.fold(
        (failure) => expect(identical(tFailure, failure), true),
        (post) => throw AssertionError(),
      );
      verify(() => mockPostRepository.deletePost(tPost));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
