import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


/// User picks a file, and once picked can read it
/// After database, deserialize data in the file to be used
void loadFile() async {
  const fileSystem = LocalFileSystem();
  var filepath = await FilePicker.platform.pickFiles();
  if (filepath != null) {
    File file = fileSystem.file(filepath);
    var contents = await file.readAsString();
    debugPrint(contents);
  } else {
    debugPrint("No file");
  }
}

