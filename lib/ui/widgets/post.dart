import 'package:flutter/material.dart';

import '../../logic/features/posts/domain/entities/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}
