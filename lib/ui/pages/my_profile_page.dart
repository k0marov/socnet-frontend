import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/di.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile/bloc/my_profile_bloc.dart';
import 'package:socnet/ui/pages/post_creation_page.dart';
import 'package:socnet/ui/pages/posts_page.dart';
import 'package:uuid/uuid.dart';

import '../../logic/features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<MyProfileBloc, MyProfileState>(
              bloc: context.read(),
              builder: (context, state) {
                if (state is MyProfileInitial) {
                  return Container();
                } else if (state is MyProfileLoading) {
                  return const CircularProgressIndicator();
                } else if (state is MyProfileLoaded) {
                  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (state.nonFatalFailure != null) Text(state.nonFatalFailure.toString()),
                    if (state.profile.avatarUrl != null)
                      Image(
                        key: Key(const Uuid().v1()),
                        image: NetworkImage("https://" + state.profile.avatarUrl!),
                      ),
                    Text(state.profile.username),
                    Text(state.profile.about),
                    Text(state.profile.followers.toString()),
                    Text(state.profile.follows.toString()),
                    TextButton(
                      child: const Text("Update about to random string"),
                      onPressed: () => context.read<MyProfileBloc>().add(
                            ProfileUpdateRequested(
                              profileUpdate: ProfileUpdate(newAbout: const Uuid().v1()),
                            ),
                          ),
                    ),
                    TextButton(
                      child: const Text("Update Avatar"),
                      onPressed: () async {
                        final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (imageFile != null) {
                          final croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
                          if (croppedImage == null) return;
                          context
                              .read<MyProfileBloc>()
                              .add(AvatarUpdateRequested(newAvatar: SimpleFile(croppedImage.path)));
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return PostsPage(profileId: state.profile.id);
                      })),
                      child: Text("View Posts"),
                    )
                  ]);
                } else if (state is MyProfileFailure) {
                  return Text(state.failure.toString());
                } else {
                  return Container();
                }
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () => context.read<AuthGateCubit>().logout(),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const PostCreationPage();
                }),
              ),
              child: const Text("New Post"),
            ),
          ],
        ),
      ),
    );
  }
}
