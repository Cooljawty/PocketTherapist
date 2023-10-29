// TODO: Convert to rootBundle.loadAssets()
/// load bundle
/// parse yml
/// store values to variables
/// access via exposed methods
/// probably try isolates for scheduling background saving of settings
/// save on close.

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:yaml/yaml.dart';
import 'package:app/provider/theme_settings.dart';

/// Used for error messages
const String prefrencesPrefix = "pocket-therapist";
/// True if loading has been completed, false otherwise.
bool _init = false;

/// True if saving is not possible.
bool _unstable = false;

/// These are the default settings and will be overwritten when laoded.

const String configuredKey = "configured";
/// true if the app has been setup before, false otherwise
bool _configured = false;

const String lightOrDarkKey = 'theme';
/// Which theme is being used currently, load and saves as an integer.
ThemeOption _currentTheme = ThemeOption.light;

const String fontScaleKey = 'fontScale';
/// Scale of all font sizes
double _fontScale = 1.0;

const String encryptionToggleKey = 'encryption';
/// True if encryption is enabled, false otherwise
bool _encryptionEnabled = true;

const String accentColorKey = "accent";
/// The color of all accents, like buttons and sizing.
Color _accentColor = Colors.blueAccent;

YamlMap? _cachedSettings;
Directory? _settingsStorageDirectory;
File? _settingsFile;
Directory? _externalStorageDirectory;

Future<void> load() async  {
  try {
    _settingsStorageDirectory = await getApplicationSupportDirectory();
    _settingsFile = File("${_settingsStorageDirectory!.path}/settings.yml");
    if(!Platform.isIOS){
      // IOS doesn't allow this to work.
      _externalStorageDirectory = await getExternalStorageDirectory();
    } else {
      _externalStorageDirectory = _settingsStorageDirectory;
    }
    debugPrint("$_settingsFile");
    // first time setup
    if(!await _settingsFile!.exists()){
      // cannot create settings file
      try {
        // attempt to create the whole directory path if it doesnt exist.
        await _settingsFile!.create();
      } on FileSystemException {
        debugPrint("Could not create settings file with path $_settingsFile!");
      }
    }
    // Else settings exists, load them.
    else {
      String fileContent = await _settingsFile!.readAsString();
      _cachedSettings = loadYaml(fileContent);
      /// Loading saved settings over the defaults
      if(_cachedSettings == null) { debugPrint("Settings failed to load. Maybe it was never saved?");};
      {

      }
    }
  } on MissingPlatformDirectoryException {
    debugPrint("Unable to get Support directory, settings will not be saved.");
    _unstable = true;
  } on UnsupportedError {
    debugPrint("Unable to get external storage directory, not on IOS, standard storage will be in application support");
    _externalStorageDirectory = _settingsStorageDirectory;
  }
}


/// The saving function [save], will save settings to [_settingsStorageDirectory]
/// in a file called "settings.yml".
/// This will not happen if the system in unable to provide a storage location.
Future<void> save() async  {
  // This should only happen if we cannot get the required directories or access.
  if(_unstable){ return; }

  // Collect all the settings
  Map<String, dynamic> encrypted = encryptor.save();
  Map<String, dynamic> settings = {
    configuredKey: _configured,
    lightOrDarkKey: _currentTheme.index,
    fontScaleKey: _fontScale,
    encryptionToggleKey: _encryptionEnabled,
    accentColorKey: _accentColor.value,
  };
  settings.addAll(encrypted);
  // Save them to the file
  debugPrint("$settings");
  String jsonEncoding = json.encode(settings);
  debugPrint(jsonEncoding);
  await _settingsFile!.writeAsString(jsonEncoding);
}


/// Setters --------------------------
void setConfigured(bool value) => _configured = value;
void setPassword(String newPassword) => encryptor.setPassword(newPassword);

/// Getters --------------------------
bool isInitialized() => _init;
bool isConfigured() => _configured;
ThemeData getCurrentTheme() => switch(_currentTheme){
    ThemeOption.highContrastLight => ThemeSettings.lightTheme,
    ThemeOption.light => ThemeSettings.lightTheme,
    ThemeOption.highContrastDark => ThemeSettings.darkTheme,
    ThemeOption.dark => ThemeSettings.darkTheme,
};
double getFontScale() => _fontScale;
bool isEncryptionEnabled() => _encryptionEnabled;
Color getAccentColor() => _accentColor;
Object? getOtherSetting(String key) {
  Object? value = _cachedSettings![key];
  if(value == null) {
    debugPrint("Settings did not have value $key");
  }
  return value;
}