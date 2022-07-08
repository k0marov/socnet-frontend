import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool canBeSubmitted;
  final Function() submit;
  const SubmitButton({Key? key, required this.canBeSubmitted, required this.submit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: canBeSubmitted ? submit : null,
      child: Text("Login"),
    );
  }
}