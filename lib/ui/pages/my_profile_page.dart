import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';
import 'package:socnet/logic/features/posts/domain/usecases/get_profile_posts_usecase.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile_cubit/my_profile_cubit.dart';
import 'package:socnet/ui/helpers.dart';
import 'package:socnet/ui/pages/post_creation_page.dart';
import 'package:socnet/ui/widgets/post.dart';
import 'package:socnet/ui/widgets/simple_future_builder.dart';

import '../../logic/di.dart';
import '../../logic/features/posts/domain/entities/post.dart';
import '../../logic/features/profile/domain/entities/profile.dart';
import '../widgets/failure_listener.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SimpleFutureBuilder<Profile>(
        future: sl<GetMyProfileUseCase>()(),
        loading: Center(child: CircularProgressIndicator()),
        loadedBuilder: (profile) => BlocProvider(
          create: (_) => sl<MyProfileCubitFactory>()(profile),
          child: _Internal(),
        ),
        failureBuilder: (failure) => Text(failure.toString()),
      ),
    );
  }
}

class _Internal extends StatelessWidget {
  const _Internal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: FailureListener<MyProfileCubit, MyProfileState>(
          getFailure: (state) => state.failure,
          child: BlocBuilder<MyProfileCubit, MyProfileState>(
            builder: (context, state) {
              return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                state.profile.avatarUrl.fold(
                  () => Text("avatar placeholder"),
                  (avatarUrl) => SizedBox(
                    width: 200,
                    height: 200,
                    child: CircleAvatar(
                      foregroundImage: NetworkImage("https://" + avatarUrl),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "@${state.profile.username}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Column(
                    children: [Text("Followers"), SizedBox(height: 5), Text(state.profile.followers.toString())],
                  ),
                  Column(
                    children: [Text("Follows"), SizedBox(height: 5), Text(state.profile.follows.toString())],
                  ),
                ]),
                SizedBox(height: 15),
                Text(state.profile.about),
                TextButton(
                  onPressed: () => pushPage(context, PostCreationPage(), true),
                  child: Text("Create new post"),
                ),
                TextButton(
                  onPressed: () => sl<LogoutUseCase>()(),
                  child: Text("Logout"),
                ),
                SimpleFutureBuilder<List<Post>>(
                  future: sl<GetProfilePostsUseCase>()(state.profile),
                  loading: Container(),
                  loadedBuilder: (posts) => ListView(
                    children: posts.map((post) => PostWidget(post: post)).toList(),
                  ),
                  failureBuilder: (failure) => Text(failure.toString()),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
