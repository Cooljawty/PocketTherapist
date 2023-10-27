// import 'dart:io';
//
// import 'package:app/provider/theme_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// const String prefrencesPrefix = "pocket-therapist";
// const String lightOrDarkKey = 'theme';
// const String storageFileKey = 'storage';
// const String fontScaleKey = 'fontScale';
// const String encryptionToggleKey = 'encryption';
// const String accentColorKey = "accent";
// const String initKey = "init";
//
// SharedPreferences? _preferences;
//
// /// Loads saved preferences, or enforces the defaults, loading them either way.
//
// void init() async {
//   SharedPreferences.setPrefix(prefrencesPrefix);
//   _preferences = await SharedPreferences.getInstance();
//   bool init = _preferences!.containsKey(initKey);
//   if (!init) {
//     //if data was initialized.
//     await _preferences!.setBool(initKey, true);
//     //Storage File name
//     Directory defaultStorageDir = await getApplicationDocumentsDirectory();
//     String defaultPath = defaultStorageDir.path;
//     await _preferences!.setString(storageFileKey, "$defaultPath/data.db");
//     //Font scaling
//     await _preferences!.setDouble(fontScaleKey, 1.0);
//     //Encryption enabled
//     await _preferences!.setBool(encryptionToggleKey, true);
//     //Accent color
//     await _preferences!.setInt(
//         accentColorKey, ThemeSettings.lightTheme.primaryColor.value);
//     //Theme key
//     await _preferences!.setBool(lightOrDarkKey, true);
//   }
//   // Preferences are loaded by default inside of SharedPreferences.
// }
//
// void setTheme(bool light) {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   _preferences!.setBool(lightOrDarkKey, light);
// }
//
// /// [setStorageFile] requires
// void setStorageFileFromString(String pathToFile) {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   File x = File(pathToFile);
//   _preferences!.setString(storageFileKey, x.path);
// }
//
// void setStorageFile(File file) async {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   await file.exists();
//   if (await Permission.storage.request().isGranted) {}
// }
//
// /// this should be used to detemine if this is the first tiem the app was launched.
// bool wasInitialized() {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   bool? initialized = _preferences!.getBool(initKey);
//   return (initialized == null) ? false : true;
// }
//
// /// [getTheme] returns a reference to the last used theme.
// ThemeData getTheme() {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   bool light = _preferences!.getBool(lightOrDarkKey)!;
//   return light ? ThemeSettings.lightTheme : ThemeSettings.darkTheme;
// }
//
// /// [getStorageFile] returns a reference to the Storage File used by the app.
// Future<String> getStorageFile() async {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   String storageFile = _preferences!.getString(storageFileKey)!;
//   return storageFile;
// }
//
// /// [getFontScale] returns the last used text scaling,
// //TODO: Integrate with native text settings
// double getFontScale() {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   return _preferences!.getDouble(fontScaleKey)!;
// }
//
// /// [isEncryptionEnabled] returns true if encryption is enabled (default)
// bool isEncryptionEnabled() {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   return _preferences!.getBool(encryptionToggleKey)!;
// }
//
// /// [getAccentColor] returns the last used accent color for the application.
// Color getAccentColor() {
//   if (_preferences == null) {
//     throw StateError("Settings was not initalized. Cannot continue.");
//   }
//   int colorValue = _preferences!.getInt(accentColorKey)!;
//   return Color(colorValue);
// }
