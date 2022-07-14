import 'package:flutter/material.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_follows_usecase.dart';
import 'package:socnet/ui/widgets/author_widget.dart';
import 'package:socnet/ui/widgets/simple_future_builder.dart';

import '../../logic/di.dart';

class FollowsPage extends StatelessWidget {
  final Profile profile;
  const FollowsPage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SimpleFutureBuilder(
        future: sl<GetFollowsUseCase>()(profile),
        loading: CircularProgressIndicator(),
        failureBuilder: (failure) => Text(failure.toString()),
        loadedBuilder: (List<Profile> follows) => ListView(
          children: follows.map((follow) => AuthorWidget(author: follow)).toList(),
        ),
      ),
    );
  }
}
