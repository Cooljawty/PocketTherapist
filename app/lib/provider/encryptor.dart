
import 'package:app/provider/settings.dart' show passwordKey, ivHashKey, storageKey;
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _preferences;

String? _passwordHash;
String? _IVCipherText;
String? _KeyCipherText;

void init(SharedPreferences preferences) {
  _preferences = preferences;
  _passwordHash = preferences.getString(passwordKey);
  _IVCipherText = preferences.getString(ivHashKey);
  _KeyCipherText = preferences.getString(storageKey);
}

void setPassword(String password) {
  //Do hash things
  _passwordHash = password;
}

bool validatePassword(String password){
    // do hash things, then compare to hash
    return password == _passwordHash;
}
