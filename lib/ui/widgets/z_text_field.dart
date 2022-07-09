import 'package:flutter/material.dart';
import 'package:socnet/logic/core/field_value.dart';

class ZTextField extends StatelessWidget {
  final FieldValue value;
  final Function(String) onChanged;
  final String label;
  final bool obscureText;
  const ZTextField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: Theme.of(context).textTheme.headline5,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        errorText: value.failure?.code,
      ),
    );
  }
}
