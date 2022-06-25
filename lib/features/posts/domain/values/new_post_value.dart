import 'package:equatable/equatable.dart';
import 'package:socnet/core/simple_file/simple_file.dart';

class NewPostValue extends Equatable {
  final List<SimpleFile> images;
  final String text;
  @override
  List get props => [images, text];
  const NewPostValue({
    required this.images,
    required this.text,
  });
}
