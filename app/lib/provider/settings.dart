import 'dart:io';

import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager with ChangeNotifier {
  static const String prefrencesPrefix = "pocket-therapist";
  static const String lightOrDarkKey = 'theme';
  static const String storageFileKey = 'storage';
  static const String fontScaleKey = 'fontScale';
  static const String encryptionToggleKey = 'encryption';
  static const String accentColorKey = "accent";
  static const String initKey = "init";

  static SettingsManager? _reference;
  late final SharedPreferences _preferences;

  SettingsManager () {
    if(_reference != null) throw StateError("Only one SettingManager at one time!");
    SharedPreferences.setPrefix(prefrencesPrefix);
    _loadPreferences();
    _reference = this;
  }
  
  /// Loads saved preferences, or enforces the defaults, loading them either way.

  _loadPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    bool init = _preferences.containsKey(initKey);
     if(!init) {
       //if data was initialized. 
      await _preferences.setBool(initKey, true);
      //Storage File name
      Directory defaultStorageDir = await getApplicationDocumentsDirectory();
      String defaultPath = defaultStorageDir.path;
      await _preferences.setString(storageFileKey, "$defaultPath/data.db");
      //Font scaling
      await _preferences.setDouble(fontScaleKey, 1.0);
      //Encryption enabled
      await _preferences.setBool(encryptionToggleKey, true);
      //Accent color
      await _preferences.setInt(accentColorKey, ThemeSettings.lightTheme.primaryColor.value);
      //Theme key
      await _preferences.setBool(lightOrDarkKey, true);
    }
    // Preferences are loaded by default inside of SharedPreferences.
  }

  static void setTheme(bool light){
    _reference!._preferences.setBool(lightOrDarkKey, light);
  }

  /// [setStorageFile] requires 
  static void setStorageFileFromString(String pathToFile){
    File x = File(pathToFile);
    _reference!._preferences.setString(storageFileKey, x.path);
  }

  static void setStorageFile(File file) async {
    await file.exists();
    if(await Permission.storage.request().isGranted){
      
    }
  }

  /// this should be used to detemine if this is the first tiem the app was launched.
  static bool wasInitialized() {
    if(_reference == null) throw StateError("Settings were not initalized, cannot continue.");
    bool? initialized =  _reference!._preferences.getBool(initKey);
    return (initialized == null) ? false : true;
  }

  /// [getTheme] returns a reference to the last used theme.
  static ThemeData getTheme() {
    if(_reference == null) throw StateError("Settings were not initalized, cannot continue.");
    bool light = _reference!._preferences.getBool(lightOrDarkKey)!;
    return light? ThemeSettings.lightTheme : ThemeSettings.darkTheme;
  } 

  /// [getStorageFile] returns a reference to the Storage File used by the app.
  static Future<String> getStorageFile() async {
    if(_reference == null) throw StateError("Settings were not initalized, cannot continue.");
    String storageFile = _reference!._preferences.getString(storageFileKey)!;
    return storageFile;
  } 

  /// [getFontScale] returns the last used text scaling, 
  //TODO: Integrate with native text settings
  static double getFontScale() {
    if(_reference == null) throw StateError("Settings were not initalized, cannot continue.");
    return _reference!._preferences.getDouble(fontScaleKey)!;  
  } 

  /// [isEncryptionEnabled] returns true if encryption is enabled (default)
  static bool isEncryptionEnabled() {
    if(_reference == null) throw StateError("Settings were not initalized, cannot continue.");
    return _reference!._preferences.getBool(encryptionToggleKey)!;
  } 

  /// [getAccentColor] returns the last used accent color for the application.
  static Color getAccentColor() {
    if(_reference == null) throw StateError("Settings were not initalized, cannot continue.");
    int colorValue= _reference!._preferences.getInt(accentColorKey)!;
    return Color(colorValue);
  } 

}
