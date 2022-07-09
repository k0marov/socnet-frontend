import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';

import '../../logic/di.dart';

class PostCreationPage extends StatelessWidget {
  const PostCreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCreationCubit>(
      create: (_) => sl<PostCreationCubitFactory>()(),
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
        child: BlocBuilder<PostCreationCubit, PostCreationState>(
            builder: (BuildContext context, PostCreationState state) => ListView(children: [
                  TextField(onChanged: context.read<PostCreationCubit>().textChanged),
                  for (final img in state.images)
                    GestureDetector(
                      onTap: () => context.read<PostCreationCubit>().imageDeleted(img),
                      child: Image.file(File(img.path)),
                    ),
                  TextButton(
                    onPressed: () async {
                      final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (imageFile != null) {
                        context.read<PostCreationCubit>().imageAdded(SimpleFile(imageFile.path));
                      }
                    },
                    child: const Text("Add image"),
                  ),
                  TextButton(
                    onPressed: context.read<PostCreationCubit>().submitPressed,
                    child: const Text("Post"),
                  )
                ])),
      ),
    );
  }
}
