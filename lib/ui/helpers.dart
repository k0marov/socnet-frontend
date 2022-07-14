import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../logic/core/simple_file.dart';

Route _routeFromWidget(Widget widget, [bool isDialog = false]) => MaterialPageRoute(
      builder: (_) => widget,
      fullscreenDialog: isDialog,
    );

void popPage(BuildContext ctx) => Navigator.of(ctx).pop();
void pushPage(BuildContext ctx, Widget page, [bool isDialog = false]) => Navigator.of(ctx).push(
      _routeFromWidget(page, isDialog),
    );
void replacePage(BuildContext ctx, Widget page) => Navigator.of(ctx).pushReplacement(_routeFromWidget(page));

Future<SimpleFile?> chooseSquareImage() async {
  final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (imageFile == null) return null;
  final croppedImage = await ImageCropper()
      .cropImage(sourcePath: imageFile.path, aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
  if (croppedImage == null) return null;
  return SimpleFile(croppedImage.path);
}
