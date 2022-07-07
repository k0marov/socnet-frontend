import 'package:flutter/material.dart';
import 'package:socnet/ui/app.dart';

import 'logic/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initialize();
  runApp(const MyApp());
}
