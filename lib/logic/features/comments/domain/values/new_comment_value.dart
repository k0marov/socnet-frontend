import 'package:equatable/equatable.dart';

class NewCommentValue extends Equatable {
  final String text;
  @override
  List get props => [text];
  const NewCommentValue({required this.text});
}
