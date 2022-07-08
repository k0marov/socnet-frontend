import 'package:flutter/material.dart';
import 'package:socnet/ui/pages/auth_gate.dart';
import 'package:socnet/ui/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: AuthGatePage(),
    );
  }
}
