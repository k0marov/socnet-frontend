import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/di.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile/bloc/my_profile_bloc.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProfileBloc>(
      create: (_) => sl()..add(ProfileLoadRequested()),
      child: const _InternalPage(),
    );
  }
}

class _InternalPage extends StatelessWidget {
  const _InternalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: FailureListener<MyProfileBloc, MyProfileState>(
            getFailure: (state) => state is MyProfileFailure ? state.failure : null,
            child: BlocBuilder<MyProfileBloc, MyProfileState>(
              builder: (context, state) {
                if (state is MyProfileInitial || state is MyProfileLoading) {
                  return CircularProgressIndicator();
                } else if (state is MyProfileLoaded) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage("https://" + state.profile.avatarUrl!),
                      ),
                    ),
                    TextFormField(
                      initialValue: state.profile.about,
                    )
                    // SizedBox(height: 15),
                    // Text(
                    //   "@${state.profile.username}",
                    //   style: Theme.of(context).textTheme.headlineSmall,
                    // ),
                    // SizedBox(height: 15),
                    // Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    //   Column(
                    //     children: [Text("Followers"), SizedBox(height: 5), Text(state.profile.followers.toString())],
                    //   ),
                    //   Column(
                    //     children: [Text("Follows"), SizedBox(height: 5), Text(state.profile.follows.toString())],
                    //   ),
                    // ]),
                    // SizedBox(height: 15),
                    // Text(state.profile.about),
                  ]);
                } else {
                  return Text("Error");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
