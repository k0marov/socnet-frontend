import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:socnet/features/posts/domain/usecases/create_post.dart';
import 'package:socnet/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/features/posts/presentation/post_creation_bloc/post_creation_bloc.dart';

import '../../../core/helpers/helpers.dart';
import '../post_helpers.dart';

class MockCreatePost extends Mock implements CreatePost {}

void main() {
  late PostCreationBloc sut;
  late MockCreatePost mockCreatePost;

  setUp(() {
    mockCreatePost = MockCreatePost();
    sut = PostCreationBloc(mockCreatePost);
  });

  test(
    "should have state = DefaultCreationState",
    () async {
      expect(sut.state, const DefaultCreationState(images: [], currentSavedText: ""));
    },
  );

  void shouldDoNothingIfAlreadyCreated() {
    test(
      "should do nothing if state is CreationSuccessful",
      () async {
        fakeAsync((async) {
          // arrange
          sut.emit(CreationSuccessful());
          // act
          sut.add(ImageAdded(newImage: createTestFile()));
          // assert
          async.elapse(const Duration(seconds: 5));
          expect(
            sut.state,
            CreationSuccessful(),
          );
          verifyZeroInteractions(mockCreatePost);
        });
      },
    );
  }

  group('ImageAdded', () {
    shouldDoNothingIfAlreadyCreated();
    test(
      "should update state with added image if state is not CreationSuccessful",
      () async {
        // arrange
        final tImage = createTestFile();
        final tInitialImages = [createTestFile(), createTestFile()];
        final tText = randomString();
        sut.emit(DefaultCreationState(images: tInitialImages, currentSavedText: tText));
        // assert later
        final expectedState = DefaultCreationState(
          images: tInitialImages + [tImage],
          currentSavedText: tText,
        );
        expect(sut.stream, emitsInOrder([expectedState]));
        // act
        sut.add(ImageAdded(newImage: tImage));
      },
    );
  });

  group('ImageDeleted', () {
    shouldDoNothingIfAlreadyCreated();
    test(
      "should update state with image removed if state is not CreationSuccessful",
      () async {
        // arrange
        final tInitialImages = [createTestFile(), createTestFile(), createTestFile()];
        final tImageToDelete = tInitialImages[1];
        final tText = randomString();
        sut.emit(DefaultCreationState(
          images: tInitialImages,
          currentSavedText: tText,
        ));
        // assert later
        final expectedImages = [tInitialImages[0], tInitialImages[2]];
        final expectedState = DefaultCreationState(
          images: expectedImages,
          currentSavedText: tText,
        );
        expect(sut.stream, emitsInOrder([expectedState]));
        // act
        sut.add(ImageDeleted(deletedImage: tImageToDelete));
      },
    );
  });

  group('PostButtonPressed', () {
    final tText = randomString();
    final tImages = [createTestFile()];
    shouldDoNothingIfAlreadyCreated();
    test(
      "should call usecase and set state to CreationSuccessful if it was successful",
      () async {
        // arrange
        sut.emit(DefaultCreationState(
          images: tImages,
          currentSavedText: "asdf",
        ));
        when(() => mockCreatePost(PostCreateParams(
              newPost: NewPostValue(
                images: tImages,
                text: tText,
              ),
            ))).thenAnswer((_) async => Right(createTestPost()));
        // assert later
        expect(sut.stream, emitsInOrder([CreationSuccessful()]));
        // act
        sut.add(PostButtonPressed(finalText: tText));
      },
    );
    test(
      "should set state to CreationFailed if the usecase call was unsuccessful",
      () async {
        // arrange
        final tFailure = randomFailure();
        sut.emit(DefaultCreationState(
          images: tImages,
          currentSavedText: "asdf",
        ));
        when(() => mockCreatePost(PostCreateParams(newPost: NewPostValue(images: tImages, text: tText))))
            .thenAnswer((_) async => Left(tFailure));
        // assert later
        expect(
            sut.stream,
            emitsInOrder([
              CreationFailed(
                failure: tFailure,
                images: tImages,
                currentSavedText: tText,
              )
            ]));
        // act
        sut.add(PostButtonPressed(finalText: tText));
      },
    );
  });
}
