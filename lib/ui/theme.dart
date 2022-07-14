import 'package:flutter/material.dart';

const customRed = Color(0xFFFF3333);
const customBlue = Color(0xFF3E74FD);
const customPink = Color(0xFFFD3EF5);
const customGreen = Color(0xFF5CFF33);
const customCyan = Color(0xFF33FFF3);

final theme = ThemeData(
  primarySwatch: Colors.blue,
);

const inputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  floatingLabelBehavior: FloatingLabelBehavior.never,
  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(10))),
  filled: true,
);
