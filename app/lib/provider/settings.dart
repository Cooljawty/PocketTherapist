import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager with ChangeNotifier {
  static const String themeKey = 'theme';
  static const String quotePathKey = 'quotePath';
  static const String settingsPathKey = 'settingsPath';
  static const String storagePathKey = 'storagePath';
  static const String fontScaleKey = 'fontScale';
  static const String encryptionToggleKey = 'encryption';
  static const String accentColorKey = "accent";

  static SettingsManager? reference;
  late final SharedPreferences _preferences;

  SettingsManager () {
    if(reference != null) throw StateError("Only one SettingManager at one time!");
    SharedPreferences.setPrefix("pocket-therapist");
    _loadPrefernces();
    reference = this;
  }

  _loadPrefernces() async {
    _preferences = await SharedPreferences.getInstance();
    if(_preferences.containsKey(""))
  }
  
  static Object getSetting(String key) {
    if(!reference is null)
      throw StateError("No self reference found, please ensure you initialized \
      SettingsManger");

    reference._preferences.get(key);
  }

  //SettingManager.<setting>()
  



}
