import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/presentation/post_cubit/post_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';
import '../../post_helpers.dart';

abstract class DeletePost {
  UseCaseReturn<void> call(Post _);
}

abstract class ToggleLike {
  UseCaseReturn<Post> call(Post _);
}

class MockDeletePost extends Mock implements DeletePost {}

class MockToggleLike extends Mock implements ToggleLike {}

void main() {
  final tPost = createTestPost();

  late PostCubit sut;
  late MockDeletePost mockDeletePost;
  late MockToggleLike mockToggleLike;

  setUp(() {
    mockDeletePost = MockDeletePost();
    mockToggleLike = MockToggleLike();
    sut = postCubitFactoryImpl(mockToggleLike, mockDeletePost)(tPost);
  });

  final tInitial = PostState(tPost, null);

  test(
    "should have initial state with the provided post",
    () async {
      expect(sut.state, tInitial);
    },
  );

  group('deletePressed()', () {
    Future<Either<Failure, void>> useCaseCall() => mockDeletePost(tPost);
    Future act() => sut.deletePressed();

    test("should set state to deleted if usecase call is successful", () async {
      when(useCaseCall).thenAnswer((_) async => Right(null));
      await act();
      expect(sut.state, tInitial.makeDeleted());
    });
    test("should add failure to state if usecase call is unsuccessful", () async {
      final tFailure = randomFailure();
      when(useCaseCall).thenAnswer((_) async => Left(tFailure));
      await act();
      expect(sut.state, tInitial.withFailure(tFailure));
    });
  });
  group("likePressed", () {
    final tPostLiked = createTestPost();

    Future<Either<Failure, Post>> useCaseCall() => mockToggleLike(tPost);
    Future act() => sut.likePressed();

    test("should update state to new post if usecase call is successful", () async {
      when(useCaseCall).thenAnswer((_) async => Right(tPostLiked));
      await act();
      expect(sut.state, tInitial.withoutFailure().withPost(tPostLiked));
    });
    test("should add failure to state if usecase call throws", () async {
      final tFailure = randomFailure();
      when(useCaseCall).thenAnswer((_) async => Left(tFailure));
      await act();
      expect(sut.state, tInitial.withFailure(tFailure));
    });
  });
}
