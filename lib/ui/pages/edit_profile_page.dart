import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/core/simple_state_cubit.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile_cubit/my_profile_cubit.dart';
import 'package:socnet/ui/helpers.dart';
import 'package:socnet/ui/theme.dart';
import 'package:socnet/ui/widgets/simple_future_builder.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../../logic/di.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SimpleFutureBuilder<Profile>(
        future: sl<GetMyProfileUseCase>()(),
        loading: CircularProgressIndicator(),
        loadedBuilder: (initialProfile) => BlocProvider<MyProfileCubit>(
          create: (_) => sl<MyProfileCubitFactory>()(initialProfile),
          child: BlocBuilder<MyProfileCubit, MyProfileState>(
            builder: (context, state) {
              return ListView(children: [
                Row(
                  children: [
                    state.profile.avatarUrl.fold(
                      () => Text("no avatar"),
                      (avatar) => CircleAvatar(
                        foregroundImage: NetworkImage("https://" + avatar),
                      ),
                    ),
                    TextButton(
                      onPressed: () => chooseSquareImage().then(
                        (newAvatar) =>
                            newAvatar != null ? context.read<MyProfileCubit>().updateAvatar(newAvatar) : null,
                      ),
                      child: Text("Set Avatar"),
                    ),
                  ],
                ),
                BlocProvider(
                  create: (_) => SimpleStateCubit(state.profile.about),
                  child: BlocBuilder<SimpleStateCubit<String>, String>(
                    builder: (context, aboutState) => Column(
                      children: [
                        TextFormField(
                          initialValue: aboutState,
                          maxLines: null,
                          onChanged: (newAbout) => context.read<SimpleStateCubit<String>>().setState(newAbout),
                          decoration: inputDecoration,
                        ),
                        SubmitButton(
                          canBeSubmitted: aboutState.isNotEmpty,
                          submit: () =>
                              context.read<MyProfileCubit>().updateProfile(ProfileUpdate(newAbout: aboutState)),
                          text: "Set About",
                        ),
                      ],
                    ),
                  ),
                )
              ]);
            },
          ),
        ),
        failureBuilder: (failure) => Text(failure.toString()),
      ),
    );
  }
}
