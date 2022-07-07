import 'dart:io';

import 'package:socnet/logic/core/simple_file.dart';

String fixture(String name) => File('test/shared/fixtures/$name').readAsStringSync();
SimpleFile fileFixture(String name) => SimpleFile("test/shared/fixtures/$name");
