import 'package:flutter_test/flutter_test.dart';
import 'package:socnet/logic/core/likeable.dart';

void main() {
  group("withLikeToggled", () {
    test("should decrement likes count and set isLiked to false if it was true", () async {
      // arrange
      final sut = Likeable(likes: 42, isLiked: true);
      // act
      final result = sut.withLikeToggled();
      // assert
      expect(result, Likeable(likes: 41, isLiked: false));
    });
    test("should increment likes count and set isLiked to true if it was false", () async {
      // arrange
      final sut = Likeable(likes: 419, isLiked: false);
      // act
      final result = sut.withLikeToggled();
      // assert
      expect(result, Likeable(likes: 420, isLiked: true));
    });
  });
}
