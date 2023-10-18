import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';


/// Opens the file picker for the user to select a file
///
/// Returns the path to the file as a Future
Future<FilePickerResult?> pickDatabaseFile() async {
  FilePickerResult? filepath = await FilePicker.platform.pickFiles();
  return filepath;
}

/// Asks the user to open a file and then prints the contents
void openDatabaseFile() async {
  var filepath = await pickDatabaseFile();
  if (filepath != null) {
    File file = File(filepath.files.single.path!);
    var contents = await file.readAsString();
    debugPrint(contents);
  } else {
    debugPrint("No file");
  }
}