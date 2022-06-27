import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/di.dart';
import 'package:socnet/features/profile/presentation/my_profile/bloc/my_profile_bloc.dart';

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
        child: BlocBuilder<MyProfileBloc, MyProfileState>(
          bloc: context.read(),
          builder: (context, state) {
            if (state is MyProfileInitial) {
              return Container();
            } else if (state is MyProfileLoading) {
              return const CircularProgressIndicator();
            } else if (state is MyProfileLoaded) {
              return Container();
              // return Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       if (state.nonFatalFailure != null)
              //         Text(state.nonFatalFailure.toString()),
              //       if (state.profile.profile.avatarUrl != null)
              //         Image(
              //             image: NetworkImage(
              //                 'https://' + state.profile.profile.avatarUrl!)),
              //       Text(state.profile.profile.username),
              //       Text(state.profile.profile.about),
              //       Text(state.profile.profile.followers.toString()),
              //       Text(state.profile.profile.follows.toString()),
              //       TextButton(
              //         child: const Text("Update about to random string"),
              //         onPressed: () => context.read<MyProfileBloc>().add(
              //             ProfileUpdateRequested(
              //                 profileUpdate: ProfileUpdate(
              //                     newAbout: const Uuid().v1(),
              //                     newAvatar: null))),
              //       ),
              //       TextButton(
              //         child: const Text("Update Avatar"),
              //         onPressed: () async {
              //           final imageFile = await ImagePicker()
              //               .pickImage(source: ImageSource.gallery);
              //           if (imageFile != null) {
              //             final croppedImage = await ImageCropper()
              //                 .cropImage(sourcePath: imageFile.path);
              //             if (croppedImage == null) return;
              //             context
              //                 .read<MyProfileBloc>()
              //                 .add(ProfileUpdateRequested(
              //                     profileUpdate: ProfileUpdate(
              //                   newAbout: null,
              //                   newAvatar: SimpleFile(
              //                       path: croppedImage.path,
              //                       filename: imageFile.name),
              //                 )));
              //           }
              //         },
              //       ),
              //       TextButton(
              //         child: const Text("Logout"),
              //         onPressed: () =>
              //             context.read<AuthGateBloc>().add(LoggedOut()),
              //       )
              //     ]);
            } else if (state is MyProfileFailure) {
              return Text(state.failure.toString());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
