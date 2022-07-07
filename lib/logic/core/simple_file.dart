import 'package:equatable/equatable.dart';

class SimpleFile extends Equatable {
  final String path;
  @override
  List get props => [path];
  const SimpleFile(this.path);
}
