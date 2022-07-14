import 'package:flutter/material.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';

class AuthorWidget extends StatelessWidget {
  final Profile author;
  const AuthorWidget({Key? key, required this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 50,
        height: 50,
        child: author.avatarUrl.fold(
          () => Icon(Icons.person),
          (avatar) => CircleAvatar(foregroundImage: NetworkImage("https://" + avatar)),
        ),
      ),
      SizedBox(width: 5),
      Text("@" + author.username, style: Theme.of(context).textTheme.titleLarge),
    ]);
  }
}
