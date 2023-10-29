import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';
import 'package:app/provider/encryptor.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:app/uiwidgets/buttons.dart';
//add line for field import
import 'package:app/uiwidgets/fields.dart';
import 'package:flutter/material.dart';
//add line for shared preferences
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/encryptor.dart' as encryptor;

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
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Title
              Container(
                width: 350,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: ThemeSettings.defaultBoxShadow,
                ),
                //child is title text
                child: Text(
                  'Pocket Therapist',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
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
                        color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: ThemeSettings.defaultBoxShadow,
                ),
                //child is title text
                child: Text(
                  'How are you "really" feeling today?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              // Start Button
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom:  40),
                child: Column(
                  children: [
                    StandardElevatedButton(
                        key: const Key("Start_Button"),
                        onPressed: () => _handleStartPress(context),
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.amber),
                        ) ,
                    ),
                    const SizedBox(height: 10),
                    // Reset Password Button
                    StandardElevatedButton(
                      key: const Key("Reset_Button"),
                      onPressed: () => _handleResetPasswordPress(context),
                      child: Text(
                        style: Theme.of(context).textTheme.bodyLarge,
                        'Reset Password',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Erase everything
                    StandardElevatedButton(
                      key: const Key("Erase_Button"),
                      onPressed: () => _handleResetEverythingPress(context),
                      child: Text(
                        style: Theme.of(context).textTheme.bodyLarge,
                        'Erase Everything',
                      ),
                    ),
                  ],
                ),
              ),
              //use a container for the quote of the day
              Container(
                width: 350,
                height: 230,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        widthFactor: 2,
                        child: Text(
                          "Quote of the Day:",
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .background,
                              fontSize: 20.0),
                        )),
                    //extra container to hold the quote
                    Container(
                      width: 310,
                      height: 150,
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .background,
                          border: Border.all(
                            //left for now
                            color: Colors.black,
                            width: 3.0,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15.0))),
                      //now we only need a text widget for quote
                      child: const Text(
                        // quote from app
                        "''Is God willing to prevent evil, but not able? Then he is not omnipotent. Is he able, but not willing? Then he is Malevolent. Is he both able and willing? Then whence cometh evil? Is he neither able nor willing? Then why call him God?''",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const TextButton(onPressed: null, child: Text("New Quote")),
                  ],
                ),
              ),
              //spacer for after erase everything and quote of the day
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

  void _handleStartPress(BuildContext context) async {
    String passwordFieldText = "";
    String verificationPassword = "";
    if (settings.isConfigured()) {
      if(settings.isEncryptionEnabled()){
        await showDialog(
          context: context,
          // Display prompt for password entry. it must be set.
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            title: const Text("Welcome Back!"),
            content: PasswordField(hintText: "Enter your password", validator: (value) {
              passwordFieldText = value ?? "";
              if(value == null || value.isEmpty) {
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
                    //create situation to save password to local storage
                    if(passwordFieldText.isNotEmpty) {
                      if(verifyPassword(passwordFieldText)) {
                        passwordFieldText = "";
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context, DashboardPage.route());
                      } else {
                        await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Theme.of(context).colorScheme.onBackground,
                              title: const Text("Incorrect Password"),
                              actions: [
                                TextButton(
                                    key: const Key('Confirm_Incorrect_Password'),
                                    onPressed: Navigator.of(context).pop,
                                    child: const Text("Ok"),
                                )
                              ],
                            )
                        );
                      }
                    }
                  },
                  child: const Text("Enter")),
            ],
          ),
        );
      }
      else {
        // Password not set, but initialized, no check, just entry to dashboard.
        Navigator.pushReplacement(
            context,
            DashboardPage.route());
      }
    }
    else {
      // Not initialized
      await showDialog(
        context: context,
        // Start user creation process.
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("Encryption?"),
          // User enters password, which is either empty (no encryption)
          // or is valid, and must be confirmed.
          content: PasswordField(
              key: const Key('Enter_Password_Field'),
              hintText: "Enter a password (Optional)",
              validator: (value) { passwordFieldText = value ?? ""; return "";}),
          actions: [
            TextButton(
                key: const Key('Create_Password'),
                onPressed: () async {
                  // if password supplied and valid
                  if(passwordFieldText.isNotEmpty && encryptor.validatePasswordField(passwordFieldText)) {
                      // begin confirmation loop (verification)
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).colorScheme.onBackground,
                          title: const Text("Confirm your password"),
                          content: PasswordField(
                              key: const Key('Confirm_Password_Field'),
                              hintText: "Confirm Password",
                              validator: (value) {
                                verificationPassword = value ?? "";
                                return;
                              }
                          ),
                          actions: [
                            TextButton(
                              key: const Key('Verify_Password'),
                              onPressed: () async {
                                bool match = passwordFieldText == verificationPassword;
                                if(match) {
                                  settings.setPassword(passwordFieldText);
                                  settings.setConfigured(true);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(DashboardPage.route());
                                } else {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Theme.of(context).colorScheme.onBackground,
                                        title: const Text("Incorrect Password"),
                                        actions: [
                                          TextButton(
                                            key: const Key('Confirm_Password_Mismatch'),
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Ok')
                                          )
                                        ],
                                      )
                                  );
                                }
                              },
                              child: const Text("Enter"),
                            ),
                          ],
                        )
                    );
                  }
                  // password was supplied, but invalid
                  else if(passwordFieldText.isNotEmpty) {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Theme.of(context).colorScheme.onBackground,
                          title: const Text("Invalid Password"),
                          content: const Text(
                            "Password must be 10+ characters and have at least one special character and number (!@#\$%^&*())"
                          ),
                          actions: [
                            TextButton(
                                key: const Key('Confirm_Password_Invalid'),
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Ok')
                            )
                          ],
                        )
                    );
                  }
                  // No password supplied
                  else {
                    //Password is empty, prompt for confirmation (ensure no encryption)
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.onBackground,
                        title: const Text("No Encryption?"),
                        content: const Text('Encryption can keep your private thoughts, private. Continue?'),
                        actions: [
                          TextButton(
                            key: const Key('Confirm_No_Password'),
                            onPressed: () {
                              settings.setPassword(""); // empty password no encryption
                              settings.setConfigured(true);
                              Navigator.of(context).pop(); // remove confirmation window
                              Navigator.of(context).pop(); // remove inital entry window
                              Navigator.pushReplacement(context, DashboardPage.route()); // Move to dashboard w/o encryption
                            }, 
                            child: const Text("Yes")
                          ),
                          TextButton(
                            key: const Key('Cancel_No_Password'),
                            onPressed: () {
                              Navigator.of(context).pop(); // remove confirmation window to entry password.
                            }, 
                            child: const Text("No")
                          ),
                        ],
                        ));
                  }
                  // This is vital to security. must sanitize these fields.
                  passwordFieldText = "";
                  verificationPassword = "";
                },
                child: const Text("Enter")),
          ],
        ),
      );
    }
  }
  void _handleResetPasswordPress(BuildContext context) async {
    String recoveryPhrase = "";
    if(settings.isConfigured()){
      await showDialog(
          context: context,
          // Display prompt for password entry. it must be set.
          builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("Reset Password"),
          content: PasswordField(
            validator: (value) {
              return null;
            },
          ),
          actions: [
            TextButton(
                key: const Key('Reset_Password'),
                onPressed: () async {
                    //Reset the password

                },
                child: const Text("Enter")),
          ],
          ),
      );

    }

  }
  void _handleResetEverythingPress(BuildContext context) async {
    if(settings.isConfigured()){
      await showDialog(
        context: context,
        // Display prompt for password entry. it must be set.
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("Reset Everything"),
          actions: [
            TextButton(
                key: const Key('Reset_Everything'),
                onPressed: () async {
                  //Reset the password
                },
                child: const Text("Yes")),
            TextButton(
                key: const Key('Dont_Reset_Everything'),
                onPressed: () async {
                  //Reset the password
                },
                child: const Text("No")),
          ],
        ),
      );

    }
  }

}





