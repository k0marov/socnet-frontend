import 'dart:io';

import 'package:socnet/core/simple_file/simple_file.dart';

String fixture(String name) => File('test/core/fixtures/$name').readAsStringSync();
SimpleFile fileFixture(String name) => SimpleFile('test/core/fixtures/$name');
