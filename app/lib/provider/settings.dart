import 'dart:convert';
import 'dart:io';

import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Used for error messages
const String prefrencesPrefix = "pocket-therapist";

/// True if loading has been completed, false otherwise.
bool _init = false;

/// These are the default settings and will be overwritten when laoded.

const String configuredKey = "configured";

/// true if the app has been setup before, false otherwise

const String themeKey = 'theme';

/// Which theme is being used currently, load and saves as an integer.

const String fontScaleKey = 'fontScale';

/// Scale of all font sizes

const String encryptionToggleKey = 'encryption';

/// True if encryption is enabled, false otherwise

const String accentColorKey = "accent";

//add tag list
List<String> tagList = [];

/// The color of all accents, like buttons and sizing.

Map<String, dynamic> _settings = {
  configuredKey: false,
  themeKey: ThemeOption.light.index,
  fontScaleKey: 1.0,
  encryptionToggleKey: false,
  accentColorKey: Colors.deepPurpleAccent[100]!.value,
};

Directory? _settingsStorageDirectory;
File? _settingsFile;
//Directory? _externalStorageDirectory;

Future<void> load() async {
  _settingsStorageDirectory = await getApplicationSupportDirectory();
  _settingsFile = File("${_settingsStorageDirectory!.path}/settings.yml");
  // first time setup
  if (!await _settingsFile!.exists()) {
    // cannot create settings file
    // attempt to create the whole directory path if it doesnt exist.
    await _settingsFile!.create();
    _assignDefaults();
  }
  // Else settings exists, load them.
  else {
    String fileContent = await _settingsFile!.readAsString();
    if (fileContent.isEmpty) {
      // Settings file exists but empty, save the defaults
      _assignDefaults();
    } else {
      // settings file exists, load it
      _settings = json.decode(fileContent);
      // Load encryption settings
      encryptor.load(_settings['enc']);

      // Erase from our reference, not used.
      _settings['enc'] = null;

      List<dynamic> dynamicList;
      //load tags
      if (_settings['tags'] != null) {
        dynamicList = _settings['tags'];
        tagList = [];
        for (int i = 0; i < dynamicList.length; i++) {
          tagList.add(dynamicList[i] as String);
        }
      }
    }

    /// settings are loaded
  }

  /// Settings - App is initialized
  _init = true;
}

void _assignDefaults() async {
  // Enforce defaults
  _settings = {
    configuredKey: false,
    themeKey: ThemeOption.light.index,
    fontScaleKey: 1.0,
    encryptionToggleKey: false,
    accentColorKey: Colors.deepPurpleAccent[100]!.value,
  };
  tagList = [
    'Calm',
    'Centered',
    'Content',
    'Fulfilled',
    'Patient',
    'Peaceful',
    'Present',
    'Relaxed',
    'Serene',
    'Trusting',
  ];
}

/// The saving function [save], will save settings to [_settingsStorageDirectory]
/// in a file called "settings.yml".
/// This will not happen if the system in unable to provide a storage location.
Future<void> save() async {
  _settingsStorageDirectory = await getApplicationSupportDirectory();
  _settingsFile = File("${_settingsStorageDirectory!.path}/settings.yml");
  // first time setup
  if (!await _settingsFile!.exists()) {
    // cannot create settings file
    // attempt to create the whole directory path if it doesnt exist.
    await _settingsFile!.create();
  }
  // Collect all the settings
  Map<String, dynamic> encrypted = encryptor.save();
  Map<String, dynamic> settings = Map.of(_settings);
  settings['enc'] = encrypted;

  //add lines to update tags
  settings['tags'] = tagList;

  // Save them to the file
  String jsonEncoding = json.encode(settings);
  await _settingsFile!.writeAsString(jsonEncoding);
}

Future<void> reset() async {
  _settings = {
    configuredKey: false,
    themeKey: ThemeOption.light.index,
    fontScaleKey: 1.0,
    encryptionToggleKey: false,
    accentColorKey: const Color(0xFFB388FF).value,
  };
  encryptor.reset();
  // Probably message database to reset as well....
  await save();
}

/// Setters --------------------------
void setConfigured(bool value) => _settings[configuredKey] = value;
void setTheme(ThemeOption theme) => _settings[themeKey] = theme.index;
void setFontScale(double newFontScale) => _settings[fontScaleKey] = newFontScale;
void setEncryptionStatus(bool newStatus) => _settings[encryptionToggleKey] = newStatus;
void setAccentColor(Color newColor) => _settings[accentColorKey] = newColor.value;
void setPassword(String newPassword) => encryptor.setPassword(newPassword);

void setMockValues(Map<String, dynamic> value) {
  reset();
  _settings.addAll(value);
}

/// Getters --------------------------
bool isInitialized() => _init;
bool isConfigured() => _settings[configuredKey];
ThemeData getCurrentTheme() => switch (_settings[themeKey] as int) {
      0 => ThemeSettings.lightTheme,
      1 => ThemeSettings.lightTheme,
      2 => ThemeSettings.darkTheme,
      3 => ThemeSettings.darkTheme,
      _ => throw StateError("Invalid ThemeSetting")
    };
double getFontScale() => _settings[fontScaleKey];
bool isEncryptionEnabled() => _settings[encryptionToggleKey];
Color getAccentColor() => Color(_settings[accentColorKey]);
Object? getOtherSetting(String key) {
  Object? value = _settings[key];
  if (value == null) {
    debugPrint("Settings did not have value $key");
  }
  return value;
}
