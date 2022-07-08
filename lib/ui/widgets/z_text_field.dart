import 'package:flutter/material.dart';
import 'package:socnet/logic/core/field_value.dart';

class ZTextField extends StatelessWidget {
  final FieldValue value;
  final Function(String) onChanged;
  final String label;
  const ZTextField({Key? key, required this.value, required this.onChanged, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: Theme.of(context).textTheme.headline5,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        // fillColor: Color(0xFF324B4F),
        errorText: value.failure?.code,
      ),
    );
  }
}
