import 'package:app/provider/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager with ChangeNotifier {
  static const String prefrencesPrefix = "pocket-therapist";
  static const String lightOrDarkKey = 'theme';
  static const String storageFile = 'storage';
  static const String fontScaleKey = 'fontScale';
  static const String encryptionToggleKey = 'encryption';
  static const String accentColorKey = "accent";
  static const String initKey = "init";

  static SettingsManager? reference;
  late final SharedPreferences _preferences;

  SettingsManager () {
    if(reference != null) throw StateError("Only one SettingManager at one time!");
    SharedPreferences.setPrefix(prefrencesPrefix);
    _loadPreferences();
    reference = this;
  }

  _loadPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    bool init = _preferences.containsKey(initKey);
     if(!init) {
      await _preferences.setBool(initKey, true);
      await _preferences.setString(storageFile, "data.db");
      await _preferences.setDouble(fontScaleKey, 1.0);
      await _preferences.setBool(encryptionToggleKey, true);
      await _preferences.setInt(accentColorKey, ThemeSettings.lightTheme.primaryColor.value);
      await _preferences.setBool(lightOrDarkKey, true);
    }
  }

  //SettingManager.<setting>()
  



}
