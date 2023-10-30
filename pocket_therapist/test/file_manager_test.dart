import 'package:pocket_therapist/helper/file_manager.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';

// TODO
void main() async {
  test("openDatabaseFile can open and read a file", () async {
    // Uses a MemoryFileSystem, test does not create files on disk
    const filename = "file.txt";
    const fileContents = "Test File";
    var fileSystem = MemoryFileSystem();
    await fileSystem.file(filename).writeAsString(fileContents);
    var data = await openDatabaseFile(fileSystem, filename);
    expect(data, fileContents);
  });
}