import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

import '../../logic/core/simple_file.dart';
import '../../logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';
import '../helpers.dart';

class PostImagesChoosingView extends StatefulWidget {
  final List<SimpleFile> images;
  final Function(int oldInd, int newInd) onReorder;
  const PostImagesChoosingView({Key? key, required this.images, required this.onReorder}) : super(key: key);

  @override
  State<PostImagesChoosingView> createState() => _PostImagesChoosingViewState();
}

enum ImagesState {
  dragging,
  notDragging,
}

class _PostImagesChoosingViewState extends State<PostImagesChoosingView> {
  ImagesState _state = ImagesState.notDragging;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _state = ImagesState.notDragging),
      child: ReorderableWrap(
        spacing: 8,
        runSpacing: 8,
        minMainAxisCount: 2,
        maxMainAxisCount: 2,
        alignment: widget.images.isEmpty ? WrapAlignment.start : WrapAlignment.center,
        needsLongPressDraggable: false,
        onReorder: widget.onReorder,
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
        children: widget.images
            .map(
              (image) => SizedBox(
                width: 150,
                height: 150,
                child: GestureDetector(
                  onLongPress: () => setState(() => _state = ImagesState.dragging),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.file(
                        File(image.path),
                      ),
                      Visibility(
                        visible: _state == ImagesState.dragging,
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
    );
  }
}
