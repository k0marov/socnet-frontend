import 'package:equatable/equatable.dart';

class SimpleFile extends Equatable {
  final String path;
  final String filename;
  @override
  List get props => [path, filename];
  const SimpleFile({required this.path, required this.filename});
}
