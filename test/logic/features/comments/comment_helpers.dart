import 'package:socnet/logic/features/comments/domain/entities/comment.dart';
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';

import '../../../shared/helpers/helpers.dart';
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
