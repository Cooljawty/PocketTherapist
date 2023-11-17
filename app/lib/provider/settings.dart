import 'dart:convert';
import 'dart:io';

import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/helper/classes.dart';

/// Used for error messages
const String prefrencesPrefix = "pocket-therapist";

/// True if loading has been completed, false otherwise.
bool _init = false;

/// These are the default settings and will be overwritten when loaded.

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
List<Tag> tagList = [];

//add emotion list
// List<Emotion> emotionList = [];
Map<String, Color> emotionList = {};

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
    // attempt to create the whole directory path if it doesn't exist.
    await _settingsFile!.create();
    _assignDefaults();
  }
  // Else settings exists, load them.
  else {
    String fileContent = await _settingsFile!.readAsString();
    debugPrint(fileContent);
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

      //load tags
      List<dynamic> dynamicList;
      if (_settings['tags'] != null) {
        dynamicList = _settings['tags'];
        tagList = [];
        for (int i = 0; i < dynamicList.length; i++) {
          tagList.add(Tag(name: dynamicList[i]['name'], color: Color(dynamicList[i]['color'])));
        }
      }

      debugPrint(tagList.length.toString());

      //load emotions
      if (_settings['emotions'] != null) {
        dynamicList = _settings['emotions'];
        emotionList = {};
        for (int i = 0; i < dynamicList.length; i++) {
          // emotionList.add(Emotion(name: dynamicList[i]['name'], color: Color(dynamicList[i]['color'])));
          emotionList.putIfAbsent(dynamicList[i]['name'], ()=> dynamicList[i]['color']);
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
    Tag(name: 'Calm', color: const Color(0xff90c6d0)),
    Tag(name: 'Centered', color: const Color(0xff794e5e)),
    Tag(name: 'Content', color: const Color(0xfff1903b)),
    Tag(name: 'Fulfilled', color: const Color(0xff59b1a2)),
    Tag(name: 'Patient', color: const Color(0xff00c5cc)),
    Tag(name: 'Peaceful', color: const Color(0xffa7d7d7)),
    Tag(name: 'Present', color: const Color(0xffff7070)),
    Tag(name: 'Relaxed', color: const Color(0xff3f6962)),
    Tag(name: 'Serene', color: const Color(0xffb7d2c5)),
    Tag(name: 'Trusting', color: const Color(0xff41aa8c)),
  ];
  emotionList = {
    'Happy': const Color(0xfffddd68),
    'Trust': const Color(0xff308c7e),
    'Fear': const Color(0xff4c4e52),
    'Sad': const Color(0xff1f3551),
    'Disgust': const Color(0xff384e36),
    'Anger': const Color(0xffb51c1c),
    'Anticipation': const Color(0xffff8000),
  };
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
    // attempt to create the whole directory path if it doesn't exist.
    await _settingsFile!.create();
  }
  // Collect all the settings
  Map<String, dynamic> encrypted = encryptor.save();
  Map<String, dynamic> settings = Map.of(_settings);
  settings['enc'] = encrypted;

  //Add each tag as a map with its name and color
	settings['tags'] = <Map<String, dynamic>>[];
	for (final tag in tagList) {
		settings['tags'].add({'name': tag.name, 'color': tag.color.value});
	}

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
void setPassword(String newPassword) async {
  await encryptor.setPassword(newPassword);
}

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
