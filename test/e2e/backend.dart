import 'dart:io' as io;

import 'package:path/path.dart' as p;

class Backend {
  late final io.Process _process;
  Future<void> setUp() async {
    await io.Process.run("./setup.sh", [], workingDirectory: _backendDir);
    _process = await io.Process.start(
      "./main",
      [],
      environment: {
        "SOCIO_STATIC_DIR": _staticDir,
        "SOCIO_STATIC_HOST": "static.example.com",
      },
      workingDirectory: _backendPath("go-socnet"),
    );
    io.sleep(Duration(seconds: 1)); // increase this value if server refuses connection with the test code
  }

  Future<void> tearDown() async {
    _process.kill();
    await io.Process.run("./cleanup.sh", [], workingDirectory: _backendDir);
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
