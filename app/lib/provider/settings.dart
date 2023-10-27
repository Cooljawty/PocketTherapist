import 'dart:io';

import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefrencesPrefix = "pocket-therapist"; // fixed prefix value
const String lightOrDarkKey = 'theme'; // bool storage
const String storageFileKey = 'storage'; // String storage
const String fontScaleKey = 'fontScale'; // double storage
const String encryptionToggleKey = 'encryption'; // bool storage
const String accentColorKey = "accent"; // int storage
const String initKey = "init";   // bool storage
const String passwordKey = "password"; // String hash storage
const String ivHashKey = "IV"; // String hash storage
const String storageKey = "KEY"; // String hash storage

SharedPreferences? _preferences;

/// Loads saved preferences, or enforces the defaults, loading them either way.
Future<void> init() async {
  _preferences = await SharedPreferences.getInstance();
  bool init = _preferences!.containsKey(initKey);
  if (!init) {
    //Storage File name
    Directory defaultStorageDir = await getApplicationDocumentsDirectory();
    String defaultPath = defaultStorageDir.path;
    await _preferences!.setString(storageFileKey, "$defaultPath/data.db");
    //Font scaling
    await _preferences!.setDouble(fontScaleKey, 1.0);
    //Accent color
    await _preferences!.setInt(
        accentColorKey, ThemeSettings.lightTheme.primaryColor.value);
    //Theme key
    await _preferences!.setBool(lightOrDarkKey, true);
  }
  // Preferences are loaded by default inside of SharedPreferences.
}

Future<void> reset() async {
  assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  _preferences!.clear();
  await init();
}

void setPassword(String password) {
  assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  _preferences!.setString(passwordKey, password);
  if(password.isEmpty) {
    _preferences!.setBool(encryptionToggleKey, false);
    _preferences!.setString(ivHashKey, "");
    _preferences!.setString(storageKey, "");
  } else {
    _preferences!.setBool(encryptionToggleKey, true);
    _preferences!.setString(ivHashKey, "");
    _preferences!.setString(storageKey, "");
  }
}

void setTheme(bool light) {
  assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  _preferences!.setBool(lightOrDarkKey, light);
}

/// [setStorageFile] requires
void setStorageFileFromString(String pathToFile) {
  assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  File x = File(pathToFile);
  _preferences!.setString(storageFileKey, x.path);
}

void setStorageFile(File file) async {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  await file.exists();
  if (await Permission.storage.request().isGranted) {}
}

/// this should be used to detemine if this is the first tiem the app was launched.
bool wasInitialized() {
  assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  bool? initialized = _preferences!.getBool(initKey);
  return (initialized == null) ? false : initialized;
}

void setInitState(bool initialized) {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  _preferences!.setBool(initKey, initialized);
}

/// [getTheme] returns a reference to the last used theme.
ThemeData getTheme() {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  bool light = _preferences!.getBool(lightOrDarkKey)!;
  return light ? ThemeSettings.lightTheme : ThemeSettings.darkTheme;
}

/// [getStorageFile] returns a reference to the Storage File used by the app.
Future<String> getStorageFile() async {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  String storageFile = _preferences!.getString(storageFileKey)!;
  return storageFile;
}

/// [getFontScale] returns the last used text scaling,
//TODO: Integrate with native text settings
double getFontScale() {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  return _preferences!.getDouble(fontScaleKey)!;
}

/// [isEncryptionEnabled] returns true if encryption is enabled (default)
bool isEncryptionEnabled() {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  return _preferences!.getBool(encryptionToggleKey)!;
}

/// [getAccentColor] returns the last used accent color for the application.
Color getAccentColor() {
assert(_preferences != null, throw StateError("Settings was not initialized, Cannot continue."));
  int colorValue = _preferences!.getInt(accentColorKey)!;
  return Color(colorValue);
}