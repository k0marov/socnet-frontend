import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';
import 'package:socnet/ui/helpers.dart';
import 'package:socnet/ui/widgets/bloc_field.dart';
import 'package:socnet/ui/widgets/post_images_choosing_view.dart';

import '../../logic/core/field_value.dart';
import '../../logic/di.dart';
import '../widgets/z_text_field.dart';

class PostCreationPage extends StatelessWidget {
  const PostCreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCreationCubit>(
      create: (_) => sl<PostCreationCubitFactory>()(),
      child: BlocListener<PostCreationCubit, PostCreationState>(
        listener: (ctx, state) => state.isCreated ? popPage(ctx) : null,
        child: const _InternalPage(),
      ),
    );
  }
}

class _InternalPage extends StatelessWidget {
  const _InternalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: Center(
        child: BlocBuilder<PostCreationCubit, PostCreationState>(
            builder: (BuildContext context, PostCreationState state) => ListView(children: [
                  Center(
                    child: WillPopScope(
                      onWillPop: () async => false,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(child: Text("Images", style: Theme.of(context).textTheme.titleLarge)),
                              SizedBox(height: 10),
                              BlocField<PostCreationCubit, PostCreationState, List<SimpleFile>>(
                                getValue: (state) => state.images,
                                buildField: (images, b) =>
                                    PostImagesChoosingView(images: images, onReorder: b.imageReordered),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocField<PostCreationCubit, PostCreationState, FieldValue>(
                    getValue: (state) => state.text,
                    buildField: (value, b) => ZTextField(
                      value: value,
                      onChanged: b.textChanged,
                      label: "Text",
                    ),
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
