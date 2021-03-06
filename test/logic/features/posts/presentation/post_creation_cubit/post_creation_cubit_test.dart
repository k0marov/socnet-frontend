import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/logic/core/error/failures.dart';
import 'package:socnet/logic/core/usecase.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';

import '../../../../../shared/helpers/helpers.dart';

abstract class CreatePost {
  UseCaseReturn<void> call(NewPostValue post);
}

class MockCreatePost extends Mock implements CreatePost {}

PostCreationState randomPostCreationState() => PostCreationState()
    .withFailure(randomFailure())
    .withText(randomFieldValue())
    .withImages([createTestFile(), createTestFile()]);

void main() {
  late PostCreationCubit sut;
  late MockCreatePost mockCreatePost;

  final tFilledState = randomPostCreationState();
  final tFailure = randomFailure();
  final tStateWithHandledFailure = randomPostCreationState();

  setUp(() {
    mockCreatePost = MockCreatePost();
    sut = postCreationCubitFactoryImpl(
      mockCreatePost,
      (state, failure) =>
          state == tFilledState.withoutFailures() && failure == tFailure ? tStateWithHandledFailure : throw Exception(),
    )();
  });

  const emptyState = PostCreationState();

  test(
    "should have state = emptyState",
    () async {
      expect(sut.state, emptyState);
    },
  );

  group("textChanged", () {
    test("should update state with new text", () async {
      final tText = randomString();
      sut.emit(tFilledState);
      sut.textChanged(tText);
      expect(sut.state, tFilledState.withText(tFilledState.text.withValue(tText)));
    });
  });

  group('imageAdded', () {
    final tImage = createTestFile();
    final tInitialImages = [createTestFile(), createTestFile()];

    test(
      "should update state with added image if state",
      () async {
        sut.emit(emptyState.withImages(tInitialImages));
        sut.imageAdded(tImage);
        expect(sut.state, emptyState.withImages(tInitialImages + [tImage]));
      },
    );
  });

  group('ImageDeleted', () {
    final tInitialImages = [createTestFile(), createTestFile(), createTestFile()];
    final tImageToDelete = tInitialImages[1];
    test(
      "should update state with image removed if state is not CreationSuccessful",
      () async {
        sut.emit(emptyState.withImages(tInitialImages));
        sut.imageDeleted(tImageToDelete);
        expect(sut.state, emptyState.withImages([tInitialImages[0], tInitialImages[2]]));
      },
    );
  });

  group("imageReordered", () {
    final tInitial = emptyState.withImages([createTestFile(), createTestFile(), createTestFile()]);
    test("should move the image forwards properly", () async {
      // arrange
      sut.emit(tInitial);
      const oldIndex = 0;
      const newIndex = 2;
      // act
      sut.imageReordered(oldIndex, newIndex);
      // assert
      expect(sut.state, tInitial.withImages([tInitial.images[1], tInitial.images[2], tInitial.images[0]]));
    });
    test("should move the image backwards properly", () async {
      // arrange
      sut.emit(tInitial);
      const oldIndex = 2;
      const newIndex = 1;
      // act
      sut.imageReordered(oldIndex, newIndex);
      // assert
      expect(sut.state, tInitial.withImages([tInitial.images[0], tInitial.images[2], tInitial.images[1]]));
    });
    test("should do nothing if any of the input indexes are not in the sane range", () async {
      // arrange
      sut.emit(tInitial);
      const inputs = [
        [-1, 0],
        [4, 0],
        [3, 0],
        [0, -1],
        [0, 3],
        [0, 4]
      ];
      // act and assert
      for (final inp in inputs) {
        sut.imageReordered(inp[0], inp[1]);
        expect(sut.state, tInitial);
      }
    });
  });

  group('PostButtonPressed', () {
    final tText = tFilledState.text.value;
    final tImages = tFilledState.images;

    Future<Either<Failure, void>> useCaseCall() => mockCreatePost(NewPostValue(
          images: tImages,
          text: tText,
        ));

    test(
      "should call usecase and set state to created if it was successful",
      () async {
        sut.emit(tFilledState);
        when(useCaseCall).thenAnswer((_) async => const Right(null));
        await sut.submitPressed();
        expect(sut.state, tFilledState.withoutFailures().makeCreated());
      },
    );
    test("should add failure to state if call was unsuccessful", () async {
      sut.emit(tFilledState);
      when(useCaseCall).thenAnswer((_) async => Left(tFailure));
      await sut.submitPressed();
      expect(sut.state, tStateWithHandledFailure);
    });
  });
}
