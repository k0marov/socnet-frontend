import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/core/const/const.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/core/simple_file.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';
import 'package:socnet/ui/helpers.dart';
import 'package:socnet/ui/theme.dart';
import 'package:socnet/ui/widgets/bloc_field.dart';
import 'package:socnet/ui/widgets/post_images_choosing_view.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../../logic/di.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
        child: ListView(children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500),
            child: SingleChildScrollView(
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
                        buildField: (images, b) => PostImagesChoosingView(images: images, onReorder: b.imageReordered),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          BlocField<PostCreationCubit, PostCreationState, FormFailure?>(
            getValue: (state) => state.text.failure,
            buildField: (failure, b) => TextField(
                onChanged: b.textChanged,
                maxLines: null,
                minLines: 2,
                maxLength: maxPostTextLength,
                decoration: inputDecoration.copyWith(
                  label: Text("Text"),
                  errorText: failure?.code,
                )),
          ),
          SizedBox(height: 8),
          BlocField<PostCreationCubit, PostCreationState, bool>(
            getValue: (state) => state.canSubmit,
            buildField: (value, b) => SubmitButton(
              canBeSubmitted: value,
              submit: context.read<PostCreationCubit>().submitPressed,
              text: "Post",
            ),
          ),
        ]),
      ),
    );
  }
}
