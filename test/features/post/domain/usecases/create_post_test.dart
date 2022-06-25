import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/features/posts/domain/repositories/post_repository.dart';
import 'package:socnet/features/posts/domain/usecases/create_post.dart';
import 'package:mocktail/mocktail.dart';

import '../../post_helpers.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockPostRepository;
  late CreatePost sut;

  setUp(() {
    mockPostRepository = MockPostRepository();
    sut = CreatePost(mockPostRepository);
  });

  test(
    "should forward the call to the repository",
    () async {
      // arrange
      final tNewPost = createTestNewPost();
      final tPost = createTestPost();
      when(() => mockPostRepository.createPost(tNewPost))
          .thenAnswer((_) async => Right(tPost));
      // act
      final result = await sut(PostCreateParams(newPost: tNewPost));
      // assert
      result.fold(
        (failure) => throw AssertionError(),
        (post) => expect(identical(post, tPost), true),
      );
      verify(() => mockPostRepository.createPost(tNewPost));
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
