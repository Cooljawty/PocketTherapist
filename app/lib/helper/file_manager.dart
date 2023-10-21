import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';


/// Opens the file picker for the user to select a file
///
/// Returns the path to the file as a Future
Future<FilePickerResult?> pickDatabaseFile() async {
  FilePickerResult? filepath = await FilePicker.platform.pickFiles();
  // for (var element in filepath!.files) {debugPrint(element.toString());}
  return filepath;
}

/// Asks the user to open a file and then prints the contents
Future<String> openDatabaseFile(String filepath) async {
  File file = File(filepath);
  var contents = await file.readAsString();
  return contents;
}

/// User picks a file, and once picked can read it
/// After database, deserialize data in the file to be used
void loadFile() async {
  var filepath = await pickDatabaseFile();
  if (filepath != null) {
    openDatabaseFile(filepath.files.single.path!);
  } else {
    debugPrint("No file");
  }
}

