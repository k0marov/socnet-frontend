import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';
import 'package:socnet/logic/core/simple_state_cubit.dart';

import '../../logic/core/simple_file.dart';
import '../../logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';
import '../helpers.dart';

enum DraggingState {
  dragging,
  notDragging,
}

typedef DraggingCubit = SimpleStateCubit<DraggingState>;

class PostImagesChoosingView extends StatelessWidget {
  final List<SimpleFile> images;
  final Function(int oldInd, int newInd) onReorder;
  const PostImagesChoosingView({Key? key, required this.images, required this.onReorder}) : super(key: key);

  Widget build(BuildContext context) {
    return BlocProvider<DraggingCubit>(
      create: (_) => DraggingCubit(DraggingState.notDragging),
      child: BlocBuilder<DraggingCubit, DraggingState>(
        builder: (context, state) => GestureDetector(
          onTap: () => context.read<DraggingCubit>().setState(DraggingState.notDragging),
          child: ReorderableWrap(
            spacing: 8,
            runSpacing: 8,
            minMainAxisCount: 2,
            maxMainAxisCount: 2,
            alignment: images.isEmpty ? WrapAlignment.start : WrapAlignment.center,
            needsLongPressDraggable: false,
            onReorder: onReorder,
            enableReorder: state == DraggingState.dragging,
            footer: Container(
              width: 150,
              height: 150,
              color: Colors.grey.shade300,
              child: IconButton(
                onPressed: () async {
                  final imageFile = await chooseSquareImage();
                  if (imageFile != null) {
                    context.read<PostCreationCubit>().imageAdded(SimpleFile(imageFile.path));
                  }
                },
                icon: Icon(Icons.add),
              ),
            ),
            children: images
                .map(
                  (image) => SizedBox(
                    width: 150,
                    height: 150,
                    child: GestureDetector(
                      onLongPress: () => context.read<DraggingCubit>().setState(DraggingState.dragging),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.file(
                            File(image.path),
                          ),
                          Visibility(
                            visible: state == DraggingState.dragging,
                            child: Positioned(
                              top: -8,
                              right: -8,
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: InkWell(
                                  onTap: () => context.read<PostCreationCubit>().imageDeleted(image),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
