import 'dart:io' as io;
import 'dart:io';

import 'package:path/path.dart' as p;

class Backend {
  final _curDir = p.join(io.Directory.current.absolute.path, "test", "e2e");
  String get _backendDir => p.join(_curDir, "backend");
  String get _workDir => p.join(_backendDir, "workdir");
  String get _staticDir => p.join(_workDir, "static");

  late final io.Process _process;
  Future<void> setUp() async {
    await io.Process.run("./setup.sh", [], workingDirectory: _backendDir, runInShell: true);
    _process = await io.Process.start(
      "./main",
      [],
      environment: {
        "SOCIO_STATIC_DIR": _staticDir,
        "SOCIO_STATIC_HOST": "static.example.com",
      },
      workingDirectory: _workDir,
    );
    io.sleep(Duration(seconds: 1)); // increase this value if server refuses connection with the test code
  }

  Future<void> tearDown() async {
    _process.kill();
    Directory(_workDir).delete(recursive: true);
  }
}
