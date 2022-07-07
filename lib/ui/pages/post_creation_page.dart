import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_bloc/post_creation_bloc.dart';

import '../../logic/di.dart';

class PostCreationPage extends StatelessWidget {
  const PostCreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCreationBloc>(
      create: (_) => sl<PostCreationBloc>(),
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
        child: BlocBuilder(
            bloc: context.read<PostCreationBloc>(),
            builder: (BuildContext context, PostCreationState state) {
              if (state is DefaultCreationState) {
                return ListView(children: [
                  TextFormField(initialValue: state.currentSavedText),
                  for (final img in state.images)
                    GestureDetector(
                      onTap: () {
                        context.read<PostCreationBloc>().add(ImageDeleted(deletedImage: img));
                      },
                      child: Image.file(File(img.path)),
                    ),
                  TextButton(
                    onPressed: () async {
                      final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (imageFile != null) {
                        context.read<PostCreationBloc>().add(
                              ImageAdded(
                                newImage: SimpleFile(imageFile.path),
                              ),
                            );
                      }
                    },
                    child: const Text("Add image"),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<PostCreationBloc>().add(const PostButtonPressed(finalText: "abracadabra"));
                    },
                    child: const Text("Post"),
                  )
                ]);
              } else if (state is CreationFailed) {
                return Text(state.failure.toString());
              } else {
                return const Text("Successfully created");
              }
            }),
      ),
    );
  }
}
