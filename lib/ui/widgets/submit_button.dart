import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool canBeSubmitted;
  final Function() submit;
  final String text;
  const SubmitButton({Key? key, required this.canBeSubmitted, required this.submit, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: canBeSubmitted ? submit : null,
        child: Text(text) //, style: Theme.of(context).textTheme.headline5),
        );
  }
}
