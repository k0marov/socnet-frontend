import 'package:flutter/material.dart';
import 'package:socnet/logic/core/field_value.dart';

class CustomTextField extends StatelessWidget {
  final FieldValue value;
  final Function(String) onChanged;
  const CustomTextField({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        errorText: value.failure?.code,
      ),
    );
  }
}
