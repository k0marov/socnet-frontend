import 'package:socnet/features/comments/domain/entities/comment.dart';
import 'package:socnet/features/comments/domain/values/new_comment_value.dart';

import '../../core/helpers/helpers.dart';
import '../profile/shared.dart';

Comment createTestComment() => Comment(
      id: randomInt().toString(),
      author: createTestProfile(),
      text: randomString(),
      likes: randomInt(),
      isMine: randomBool(),
      isLiked: randomBool(),
      createdAt: randomTime(),
    );

NewCommentValue createTestNewComment() => NewCommentValue(
      text: randomString(),
    );
