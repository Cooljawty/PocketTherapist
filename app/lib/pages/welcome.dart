import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/settings.dart' as settings;
import 'package:app/uiwidgets/buttons.dart';
import 'package:app/provider/theme_settings.dart';
//add line for field import
import 'package:app/uiwidgets/fields.dart';
import 'package:flutter/material.dart';
import '../uiwidgets/decorations.dart';

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
        child: Stack(
          children: [

            // Gradient
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    settings.getCurrentTheme().colorScheme.primary,
                    settings.getCurrentTheme().colorScheme.secondary,
                    settings.getCurrentTheme().colorScheme.secondary,
                    settings.getCurrentTheme().colorScheme.background,
                  ],
                ),
              ),
            ),

            // Stripe
            Transform(
              transform: Matrix4.skewY(-0.45),
              origin: const Offset(60, 0),
              alignment: Alignment.bottomLeft, //changing the origin
              child: Container(
                decoration: BoxDecoration(
                  color: darkenColor(settings.getCurrentTheme().colorScheme.secondary, .1),
                  //borderRadius: BorderRadius.circular(10.0),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),

            // Top primary color
            Transform(
              transform: Matrix4.skewY(-0.45),
              alignment: Alignment.bottomLeft, //changing the origin
              child: Container(
                decoration: BoxDecoration(
                  color: settings.getCurrentTheme().colorScheme.onBackground,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),

            // Wavy circle behind logo
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/circleCutOut.png',
                  scale: .85,
                  color: darkenColor(settings.getCurrentTheme().colorScheme.onBackground, .1),
                ),
              ),
            ),

            // The top of the stack
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 50)),

                  // Logo with catch phrase
                  SizedBox(
                      height: 250,
                      width: 250,
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage('assets/logoSmall.png'),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(0, -37, 0),
                            child: Container(
                              alignment: Alignment.center,
                              width: 190,
                              height: 30,
                              decoration: BoxDecoration(
                                color: darkenColor(Theme.of(context).colorScheme.onBackground, 0.1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'How are you ',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    ' really ',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.amber,
                                        fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    ' feeling?',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  // ),

                  // Buttons
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // Start button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: StandardElevatedButton(
                          key: const Key("Start_Button"),
                          onPressed: () => _handleStartPress(context),
                          child: const Text(
                            'Start',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                      ),

                      // Reset Password Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: StandardElevatedButton(
                          key: const Key("Reset_Button"),
                          onPressed: () => _handleResetPasswordPress(context),
                          child: Text(
                            style: Theme.of(context).textTheme.bodyLarge,
                            'Reset Password',
                          ),
                        ),
                      ),

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

                  //use a size box for the quote of the day
                  SizedBox(
                    height: 180,
                    child: Padding(padding: const EdgeInsets.only(left: 20, right: 20), child: Quote()),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
            ),
          ],
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
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        foregroundColor: Theme.of(context).colorScheme.background,
        shape: const CircleBorder(eccentricity: 1.0),
        child: const Icon(Icons.settings),
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
  void _handleStartPress(BuildContext context) async {
    if (settings.isConfigured()) {
      if (settings.isEncryptionEnabled()) {
        _attemptLogin(context);
      } else {
        // Password not set, but initialized, no check, just entry to dashboard.
        Navigator.pushReplacement(context, DashboardPage.route());
      }
    } else {
      _createPassword(context);
    }
  }

  /// [_handleResetPasswordPress] - Requests the users 5 word phrase and interacts
  ///                             with [encryptor] to perform verification and reset
  ///                             If successful will start the [_createPassword]
  ///                             Process.
  void _handleResetPasswordPress(BuildContext context) async {
    // if (settings.isConfigured()) {
    //   await showDialog(
    //     context: context,
    //     builder: (context) =>
    //         AlertDialog(
    //           backgroundColor: Theme
    //               .of(context)
    //               .colorScheme
    //               .onBackground,
    //           title: const Text("Reset Password"),
    //           content: ControlledTextField(
    //             validator: (value) {
    //               return null;
    //             },
    //           ),
    //           actions: [
    //             TextButton(
    //                 key: const Key('Reset_Password'),
    //                 onPressed: () async {
    //                   //Reset the password
    //
    //                 },
    //                 child: const Text("Enter")),
    //           ],
    //         ),
    //   );
    // }
  }

  /// [_handleResetEverythingPress] - Requests confirmation, if confirmed, erases
  ///                                 all user data & passwords securely.
  void _handleResetEverythingPress(BuildContext context) async {
    // if (settings.isConfigured()) {
    //   await showDialog(
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
    //                 onPressed: () async {
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

  void _createPassword(BuildContext context) async {
    String password = "";
    // Not initialized
    await showDialog(
      context: context,
      // Start user creation process.
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
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
            }),
        actions: [
          TextButton(
              key: const Key('Create_Password'),
              onPressed: () => _confirmPassword(context, password),
              child: const Text("Enter")),
        ],
      ),
    );
  }

  void _confirmPassword(BuildContext context, String password) async {
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
                    onPressed: () => match? _finishConfiguration(context, password): null,
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
                      onPressed: () => _finishConfiguration(context, password),
                      child: const Text("Yes")
                  ),
                  
                  TextButton(
                      key: const Key('Cancel_No_Password'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // remove confirmation window to entry password.
                      },
                      child: const Text("No")),
                ],
              ));
    }
    // This is vital to security. must sanitize these fields.
    password = "";
    match = false;
  }

  void _finishConfiguration(BuildContext context, String password) async {
    settings.setPassword(password); // empty password no encryption
    settings.setEncryptionStatus(password.isNotEmpty);
    settings.setConfigured(true);
    settings.save();
    Navigator.of(context).pop(); // remove confirmation window
    Navigator.of(context).pop(); // remove initial entry window
    Navigator.pushReplacement(
        context, DashboardPage.route()); // Move to dashboard w/o encryption
  }

  void _attemptLogin(BuildContext context) async {
    String passwordFieldText = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text("Welcome Back!"),
        content: ControlledTextField(
          key: const Key("Login_Password_Field"),
          hintText: "Enter your password",
          validator: (value) {
            passwordFieldText = value ?? "";
            if (value == null || value.isEmpty) {
              return "Field is empty!";
            }
            return null;
          },
        ),
        actions: [
          // Entering the password, verify, and then report to user.
          TextButton(
              //add key for testing
              key: const Key('Submit_Password'),
              onPressed: () async {
                await _verifyPassword(context, passwordFieldText);
              },
              child: const Text("Enter")),
        ],
      ),
    );
  }

  Future<void> _verifyPassword(BuildContext context, String password) async {
    bool match = await encryptor.unlock(password);
    if (match) {
      password = "";
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(context, DashboardPage.route());
      }
    } else {
      if (context.mounted) {
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
                ));
      } else {
        throw StateError(
            "Context was not mounted while trying to draw IncPassword Dialog");
      }
      // I should never get here
    }
  }
}
