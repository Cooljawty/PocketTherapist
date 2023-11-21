import 'dart:convert';
import 'dart:io';

import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/helper/classes.dart';

import '../pages/dashboard.dart';
import '../uiwidgets/fields.dart';

/// Used for error messages
const String preferencesPrefix = "pocket-therapist";

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
Future<void> setPassword(String newPassword) async => encryptor.setPassword(newPassword);

void setMockValues(Map<String, dynamic> value) {
  reset();
  _settings.addAll(value);
  if (_settings.containsKey('enc')) {
    encryptor.load(_settings['enc']);
  }
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

String getVaultFolder() => _settingsStorageDirectory!.path;

/// [_handleResetEverythingPress] - Requests confirmation, if confirmed, erases
///                                 all user data & passwords securely.
void handleResetEverythingPress(BuildContext context)  {
  // if (settings.isConfigured()) {
  // await showDialog(
  //     context: context,
  //     // Display prompt for password entry. it must be set.
  //     builder: (context) =>
  //         AlertDialog(
  //           backgroundColor: Theme
  //               .of(context)
  //               .colorScheme
  //               .onBackground,
  //           title: const Text("Reset Everything"),
  //           actions: [
  //             TextButton(
  //                 key: const Key('Reset_Everything'),
  //                 onPressed: () {
  //                   //Reset the password
  //                 },
  //                 child: const Text("Yes")),
  //             TextButton(

  //                 key: const Key('Don't_Reset_Everything'),
  //                 onPressed: () async {
  //                   //Reset the password
  //                 },
  //                 child: const Text("No")),
  //           ],
  //         ),
  //   );
  // }
}

void verifyPassword(BuildContext context, String password) async  {
  bool match = encryptor.unlock(password);
  if (match) {
    password = "";
    Navigator.of(context).pop();
    Navigator.pushReplacement(context, DashboardPage.route());
  }
  else {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("Incorrect Password"),
          actions: [
            TextButton(
              key: const Key(
                  'Incorrect_Password'),
              onPressed: () async {
                Navigator
                    .of(context)
                    .pop();
              },
              child: const Text("Ok"),
            )
          ],
        )
    );
    // I should never get here
  }
}

void attemptLogin(BuildContext context) async {
  String passwordFieldText = "";
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .onBackground,
      title: const Text("Welcome Back!"),
      content: ControlledTextField(
        key: const Key("Login_Password_Field"),
        hintText: "Enter your password", validator: (value) {
        passwordFieldText = value ?? "";
        if (value == null || value.isEmpty) {
          return "Field is empty!";
        }
        return null;
      },),
      actions: [
        // Entering the password, verify, and then report to user.
        TextButton(
          //add key for testing
            key: const Key('Submit_Password'),
            onPressed: () async {
              verifyPassword(context, passwordFieldText);
            },
            child: const Text("Enter")
        ),
      ],
    ),
  );
}

void finishConfiguration(BuildContext context, String password) async {
  setPassword(password); // empty password no encryption
  setConfigured(true);
  Navigator.of(context).pop(); // remove confirmation window
  Navigator.of(context).pop(); // remove initial entry window
  Navigator.pushReplacement(
      context, DashboardPage.route()); // Move to dashboard w/o encryption
  await save();
}

void confirmPassword(BuildContext context, String password) async {
  bool match = false;
  // if password supplied and valid
  if (password.isNotEmpty) {
    // begin confirmation loop (verification)
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("Confirm your password"),
          content: ControlledTextField(
              key: const Key('Confirm_Password_Field'),
              hintText: "Confirm Password",
              validator: (value) {
                match = password == value;
                return match ? null : "Passwords do not match.";
              }),
          actions: [
            TextButton(
              key: const Key('Verify_Password'),
              onPressed: () async => (match) ? finishConfiguration(context, password): null,
              child: const Text("Enter"),
            ),
          ],
        ));
  }
  // No password supplied
  else {
    //Password is empty, prompt for confirmation (ensure no encryption)
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("No Encryption?"),
          content: const Text(
              'Encryption can keep your private thoughts, private. Continue?'),
          actions: [
            TextButton(
                key: const Key('Confirm_No_Password'),
                onPressed: () => finishConfiguration(context, password),
                child: const Text("Yes")),
            TextButton(
                key: const Key('Cancel_No_Password'),
                onPressed: () async {
                  Navigator.of(context)
                      .pop(); // remove confirmation window to entry password.
                },
                child: const Text("No")),
          ],
        )
    );
  }
  password = "";
  match = false;
}

Future<void> createPassword(BuildContext context) async {
  String password = "";
  // Not initialized
  await showDialog(
    context: context,
    // Start user creation process.
    builder: (context) =>
        AlertDialog(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .onBackground,
          title: const Text("Encryption?"),
          // User enters password, which is either empty (no encryption)
          // or is valid, and must be confirmed.
          content: ControlledTextField(
              key: const Key('Enter_Password_Field'),
              hintText: "Enter a password (Optional)",
              validator: (value) {
                String? message = encryptor.defaultValidator(value);
                password = value ?? "";
                return message;
              }
          ),
          actions: [
            TextButton(
                key: const Key('Create_Password'),
                onPressed: () async =>  confirmPassword(context, password),
                child: const Text("Enter")),
          ],
        ),
  );

}

/// [_handleStartPress] handles taps of the start button, it uses the next 5
/// methods
/// - [_createPassword] - Creates the password if we are in that state
/// - [_confirmPassword] - Accepts a 2nd password to compare to the 1st
/// - [_finishConfiguration] - Completes the configuration process for passwords
///                           and recovery phrases
/// - [_attemptLogin] - Attempts to the log the user in after receiving the
///                     credentials
/// - [_verifyPassword] - Displays the errors or completes the transition to
///                       the DashboardPage
void handleStartPress(BuildContext context) async {
  if (isConfigured()) {
    if (isEncryptionEnabled()) {
      attemptLogin(context);
    } else {
      // Password not set, but initialized, no check, just entry to dashboard.
      Navigator.pushReplacement(context, DashboardPage.route());
    }
  }
  else {
    await createPassword(context).whenComplete(() async {
      if(isEncryptionEnabled()) {
        await showDialog(
            context: context,
            builder: (context) {
              String? recovery = encryptor.getRecoveryPhrase();
              return AlertDialog(
                  title: const Text("Recovery Phrase"),
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .onBackground,
                  actions: [
                    TextButton(
                        key: const Key("Recovery_Phrase_Confirm"),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Ok")),
                    TextButton(
                        key: const Key("Recovery_Phrase_Copy"),
                        onPressed: () =>
                            Clipboard.setData(ClipboardData(text: recovery!)),
                        child: const Text("Copy")),
                  ],
                  content: Text(recovery!));
            });
      }
    });
  }
}

/// [_handleResetPasswordPress] - Requests the users 5 word phrase and interacts
///                             with [encryptor] to perform verification and reset
///                             If successful will start the [_createPassword]
///                             Process.
void handleResetPasswordPress(BuildContext context) async {
  String? maybePasswordOrPhrase = "";
  if (isConfigured()) {
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .onBackground,
            title: const Text("Reset Password"),
            content: ControlledTextField(
              key: const Key("Reset_Password_Field"),
              hintText: "Enter your recovery phrase or password",
              validator: (value) {
                maybePasswordOrPhrase = value;
                if (value == null || value.isEmpty){
                  return "Field is required.";
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                  key: const Key('Reset_Password_Button'),
                  onPressed: () async {
                    bool match = encryptor.resetCredentials(maybePasswordOrPhrase!);
                    if(match) {
                      await showDialog(context: context, builder: (context) => AlertDialog(
                          backgroundColor: Theme
                              .of(context)
                              .colorScheme
                              .onBackground,
                          title: const Text("Password Reset Successful"),
                          actions: [ TextButton(
                              key: const Key("Success_Pass_Reset"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"))
                          ]
                      )).whenComplete(() async => handleStartPress(context));
                    }
                    else {
                      await showDialog(context: context, builder: (context) => AlertDialog(
                          backgroundColor: Theme
                              .of(context)
                              .colorScheme
                              .onBackground,
                          title: const Text("Incorrect Password or Recovery Phrase"),
                          actions: [ TextButton(
                              key: const Key("Fail_Pass_Reset"),
                              onPressed: () => Navigator.pop(context), child: const Text("Ok"))]));
                    }
                  },
                  child: const Text("Enter")),
            ],
          ),
    );
  }
}
