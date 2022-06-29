import 'dart:io' as io;

import 'package:path/path.dart' as p;

class Backend {
  late final io.Process process;

  Future<void> setUp() async {
    process = await io.Process.start(
      _backendPath("run.sh"),
      [],
      workingDirectory: _backendDir,
    );
  }

  Future<void> tearDown() async {
    process.kill();
  }
}

String staticPath(String path) {
  return p.join(_staticDir, path);
}

final _curDir = p.join(io.Directory.current.absolute.path, "test", "e2e");
final _backendDir = _absPath("backend");
final _staticDir = _backendPath("static");

String _absPath(String path) {
  return p.join(_curDir, path);
}

String _backendPath(String path) {
  return p.join(_backendDir, path);
}
