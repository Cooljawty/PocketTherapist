// import 'package:path_provider/path_provider.dart';
// import 'package:yaml/yaml.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
//
// class SettingsManager with ChangeNotifier {
//   late final Map<String, Object> _settings;
//   late final String _storagePath;
//
//   SettingsManager() {
//     _loadSettings();
//   }
//
//   void _loadSettings() async {
//     final directory = await getApplicationDocumentsDirectory();
//     _storagePath = directory.path;
//     var settingsFile = File("$_storagePath/settings.yml");
//     String contents = await settingsFile.readAsString();
//     var contentAsYml = loadYaml(contents);
//     _settings = contentAsYml['Settings'];
//   }
//
//   String get getStoragePath {
//     return _storagePath.toString();
//   }
// }
