import 'dart:io';

import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/theme_settings.dart';
import 'package:app/uiwidgets/buttons.dart';
//add line for field import
import 'package:app/uiwidgets/fields.dart';
import 'package:flutter/material.dart';

import '../uiwidgets/decorations.dart';
import 'package:flutter/services.dart';

/// This boolean prevents the buttons from being spam clicked when encryption is running.
bool _disabled = false;

//create welcome page class like in app example starting with stateful widget
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //duplicate build method from example with changes noted below
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Title
                Container(
                  width: 350,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: ThemeSettings.defaultBoxShadow,
                  ),
                  //child is title text
                  child: Text(
                    'Pocket Therapist',
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                ),
                // Logo
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        boxShadow: ThemeSettings.defaultBoxShadow,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Image(
                        image: AssetImage('assets/logoSmall.png'),
                      )
                  ),
                ),
                // Catch Phrase
                Container(
                  width: 280,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: ThemeSettings.defaultBoxShadow,
                  ),
                  //child is title text
                  child: Text(
                    'How are you "really" feeling today?',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                ),
                // Start Button
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 40),
                  child: Column(
                    children: [
                      StandardElevatedButton(
                        key: const Key("Start_Button"),
                        onPressed: () => _handleStartPress(context),
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Reset Password Button
                      StandardElevatedButton(
                        key: const Key("Reset_Button"),
                        onPressed: () {
                          _handleResetPasswordPress(context);
                        },
                        child: Text(
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          'Reset Password',
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Erase everything
                      StandardElevatedButton(
                        key: const Key("Erase_Button"),
                        onPressed: () => _handleResetEverythingPress(context),
                        child: Text(
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          'Erase Everything',
                        ),
                      ),
                    ],
                  ),
                ),
                //use a container for the quote of the day
                Quote(),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        //add key for testing
        key: const Key('Settings_Button'),
        onPressed: () {
          Navigator.push(
            // Go to settings page
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()));
        },
        tooltip: 'Settings',
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .onBackground,
        foregroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        shape: const CircleBorder(eccentricity: 1.0),
        child: const Icon(Icons.settings),
      ),
    );
  }

  /// [_handleStartPress] handles taps of the start button, it uses the next 5
  /// methods
  /// - [_createPassword] - Creates the password if we are in that state
  /// - [_confirmPassword] - Accepts a 2nd password to compare to the 1st
  /// - [_finishConfiguraton] - Completes the configuraiton process for passwords
  ///                           and recovery phrases
  /// - [_attemptLogin] - Attempts to the log the user in after receiving the
  ///                     credentials
  /// - [_verifyPassword] - Displays the errors or completes the transition to
  ///                       the DashboardPage
  void _handleStartPress(BuildContext context)  {
    if (settings.isConfigured()) {
      if (settings.isEncryptionEnabled()) {
        _attemptLogin(context);
      }
      else {
        // Password not set, but initialized, no check, just entry to dashboard.
        Navigator.pushReplacement(
            context,
            DashboardPage.route());
      }
    }
    else {
      _createPassword(context);
    }

  }

  /// [_handleResetPasswordPress] - Requests the users 5 word phrase and interacts
  ///                             with [encryptor] to perform verification and reset
  ///                             If successful will start the [_createPassword]
  ///                             Process.
  void _handleResetPasswordPress(BuildContext context) {
    String? maybePasswordOrPhrase = "";
    if (settings.isConfigured()) {
      showDialog(
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
                    onPressed: () {
                      bool match = encryptor.resetCredentials(maybePasswordOrPhrase!);
                      if(match) {
                        showDialog(context: context, builder: (context) => AlertDialog(
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
                        )).whenComplete(() => _handleStartPress(context));
                      }
                      else {
                        showDialog(context: context, builder: (context) => AlertDialog(
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

  /// [_handleResetEverythingPress] - Requests confirmation, if confirmed, erases
  ///                                 all user data & passwords securely.
  void _handleResetEverythingPress(BuildContext context)  {
    // if (settings.isConfigured()) {
    //   showDialog(
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
    //                 key: const Key('Dont_Reset_Everything'),
    //                 onPressed: () {
    //                   //Reset the password
    //                 },
    //                 child: const Text("No")),
    //           ],
    //         ),
    //   );
    // }
  }

  void _createPassword(BuildContext context)  {
    String password = "";
    // Not initialized
    showDialog(
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
                  onPressed: () => _confirmPassword(context, password),
                  child: const Text("Enter")),
            ],
          ),
    ).whenComplete(() {
    if(settings.isEncryptionEnabled()){
      showDialog(
  
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
                onPressed: () => Clipboard.setData(ClipboardData(text: recovery!)),
                child: const Text("Copy")),
          ],
          content: Text(recovery!));
      });
    }
    });
  }

  void _confirmPassword(BuildContext context, String password) {
    bool match = false;
    // if password supplied and valid
    if (password.isNotEmpty) {
      // begin confirmation loop (verification)
      showDialog(barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .onBackground,
                title: const Text("Confirm your password"),
                content: ControlledTextField(
                    key: const Key('Confirm_Password_Field'),
                    hintText: "Confirm Password",
                    validator: (value) {
                      match = password == value;
                      return match ? null : "Passwords do not match.";
                    }
                ),
                actions: [
                  TextButton(
                    key: const Key('Verify_Password'),
                    onPressed: () => (match && !_disabled) ? _finishConfiguraton(context, password): null,
                    child: const Text("Enter"),
                  ),
                ],
              )
      ).whenComplete(() => _disabled = false);
    }
    // No password supplied
    else {
      //Password is empty, prompt for confirmation (ensure no encryption)
      showDialog(barrierDismissible: false,
          context: context,
          builder: (context) =>
              AlertDialog(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .onBackground,
                title: const Text("No Encryption?"),
                content: const Text(
                    'Encryption can keep your private thoughts, private. Continue?'),
                actions: [
                  TextButton(
                      key: const Key('Confirm_No_Password'),
                      onPressed: () => _finishConfiguraton(context, password),
                      child: const Text("Yes")
                  ),
                  TextButton(
                      key: const Key('Cancel_No_Password'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // remove confirmation window to entry password.
                      },
                      child: const Text("No")
                  ),
                ],
              ));
    }
    password = "";
    match = false;
  }

  void _finishConfiguraton(BuildContext context, String password)  {
    _disabled = true;
    settings.setPassword(password); // empty password no encryption
    settings.setConfigured(true);
    settings.save();
    Navigator.of(context).pop(); // remove confirmation window
    Navigator.of(context).pop(); // remove inital entry window
    Navigator.pushReplacement(
        context, DashboardPage.route()); // Move to dashboard w/o encryption
  }

  void _attemptLogin(BuildContext context)  {
    String passwordFieldText = "";
    showDialog(

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
                  onPressed: () {
                    if(!_disabled) {
                      _disabled = true;
                      _verifyPassword(context, passwordFieldText);
                    }
                  },
                  child: const Text("Enter")
              ),
            ],
          ),
    );
  }

  void _verifyPassword(BuildContext context, String password)  {
    bool match = encryptor.unlock(password);
    if (match) {
      password = "";
        Navigator.of(context).pop();
        Navigator.pushReplacement(context, DashboardPage.route());
    }
    else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                AlertDialog(
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .onBackground,
                  title: const Text("Incorrect Password"),
                  actions: [
                    TextButton(
                      key: const Key(
                          'Incorrect_Password'),
                      onPressed: () {
                        Navigator
                            .of(context)
                            .pop();
                        _disabled = false;
                      },
                      child: const Text("Ok"),
                    )
                  ],
                )
        );
      // I should never get here
    }
  }
}
