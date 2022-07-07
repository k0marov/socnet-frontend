import "package:flutter/material.dart";

class PostsPage extends StatelessWidget {
  final String profileId;
  const PostsPage({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Posts of $profileId")),
    );
  }
}
