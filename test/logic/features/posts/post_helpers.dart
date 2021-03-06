import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';

import '../../../shared/helpers/helpers.dart';
import '../profile/shared.dart';

PostImage createTestPostImage() => PostImage(randomInt(), randomString());

Post createTestPost() => Post(
      id: randomInt().toString(),
      author: createTestProfile(),
      createdAt: randomTime(),
      images: [
        createTestPostImage(),
        createTestPostImage(),
      ],
      text: randomString(),
      likes: randomInt(),
      isLiked: randomBool(),
      isMine: randomBool(),
    );

NewPostValue createTestNewPost() => NewPostValue(
      images: [createTestFile()],
      text: randomString(),
    );
