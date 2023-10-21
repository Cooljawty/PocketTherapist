import 'package:app/helper/file_manager.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

// TODO
void main() async {
  test("openDatabaseFile can open and read a file", () async {
    const filename = "file.txt";
    const fileContents = "Test File";
    await File(filename).writeAsString(fileContents);
    var data = await openDatabaseFile(filename);
    expect(data, fileContents);
    openDatabaseFile(filename);
  });
}