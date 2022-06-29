import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

final curDir = p.join(io.Directory.current.absolute.path, "test", "e2e");
String absPath(String path) {
  return p.join(curDir, path);
}

final backendDir = absPath("backend");
String backendPath(String path) {
  return p.join(backendDir, path);
}

final staticDir = backendPath("static");
String staticPath(String path) {
  return p.join(staticDir, path);
}

void main() {
  late final io.Process backendProcess;
  setUpAll(() async {
    backendProcess = await io.Process.start(
      backendPath("run.sh"),
      [],
      workingDirectory: backendDir,
    );
  });
  tearDownAll(() async {
    backendProcess.kill();
  });
}
