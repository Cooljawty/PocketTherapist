// Page imports
import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';

// Provider imports
import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:app/provider/settings.dart' as settings;
import 'package:app/provider/theme_settings.dart';

// Widget imports
import 'package:app/uiwidgets/buttons.dart';
import '../uiwidgets/decorations.dart';
import 'package:app/uiwidgets/fields.dart';

// Dependency imports
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/services.dart';

//create welcome page class like in app example starting with stateful widget
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {

  //
  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  //duplicate build method from example with changes noted below
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            WaveWidget(
              config: CustomConfig(
                gradients: [
                  [
                    settings.getCurrentTheme().colorScheme.primary,
                    settings.getCurrentTheme().colorScheme.secondary
                  ],
                  [
                    settings.getCurrentTheme().colorScheme.secondary,
                    settings.getCurrentTheme().colorScheme.onBackground
                  ],
                  [
                    settings.getCurrentTheme().colorScheme.onBackground,
                    settings.getCurrentTheme().colorScheme.background
                  ],
                  [
                    settings.getCurrentTheme().colorScheme.background,
                    settings.getCurrentTheme().colorScheme.primary
                  ],
                ],
                durations: [
                  19440,
                  17440,
                  15440,
                  13440,
                ],
                heightPercentages: [0.50, 0.63, 0.75, 0.80],
                gradientBegin: Alignment.centerLeft,
                gradientEnd: Alignment.centerRight,
                blur: const MaskFilter.blur(BlurStyle.solid, 40),
              ),
              backgroundColor: settings.getCurrentTheme().colorScheme.secondary,
              size: const Size(double.infinity, double.infinity),
              // waveAmplitude: 1,
            ),

            // Stripe
            Transform(
              transform: Matrix4.skewY(-0.45),
              origin: const Offset(60, 0),
              alignment: Alignment.bottomLeft, //changing the origin
              child: Container(
                decoration: BoxDecoration(
                  color: darkenColor(
                      settings.getCurrentTheme().colorScheme.secondary, .05),
                  //borderRadius: BorderRadius.circular(10.0),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),

            // // Top primary color
            Transform(
              transform: Matrix4.skewY(-0.45),
              alignment: Alignment.bottomLeft, //changing the origin
              child: Container(
                decoration: BoxDecoration(
                  color: settings.getCurrentTheme().colorScheme.primary,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),

            // Intractable widgets and the logo
            SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 50)),

                    // Contains the logo, spinning circle, and catch phrase
                    SizedBox(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Wavy circle behind logo
                            Container(
                              alignment: Alignment.topCenter,
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (_, child) {
                                  return Transform.rotate(
                                    angle: _controller.value * .12 * math.pi,
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  'assets/circleCutOut.png',
                                  scale: .8,
                                  color: darkenColor(
                                      settings.getCurrentTheme().colorScheme.primary, .1),
                                ),
                              ),
                            ),

                            // Logo
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      color: darkenColor(
                                          settings.getCurrentTheme()
                                              .colorScheme
                                              .primary,
                                          0.1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'How are you ',
                                          style:
                                          Theme.of(context).textTheme.bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          ' really ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                            color: Colors.amber,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          ' feeling?',
                                          style:
                                          Theme.of(context).textTheme.bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                    ),
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
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Quote()),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              ),
            ),
          ],
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
        ));
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
    }
    else {
      await _createPassword(context).whenComplete(() async {
        if(settings.isEncryptionEnabled()) {
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
  void _handleResetPasswordPress(BuildContext context) async {
    String? maybePasswordOrPhrase = "";
    if (settings.isConfigured()) {
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
                        )).whenComplete(() async => _handleStartPress(context));
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

  /// [_handleResetEverythingPress] - Requests confirmation, if confirmed, erases
  ///                                 all user data & passwords securely.
  void _handleResetEverythingPress(BuildContext context)  {
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

  Future<void> _createPassword(BuildContext context) async {
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
                  onPressed: () async =>  _confirmPassword(context, password),
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
                    onPressed: () async => (match) ? _finishConfiguration(context, password): null,
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

  void _finishConfiguration(BuildContext context, String password) async {
    settings.setPassword(password); // empty password no encryption
    settings.setConfigured(true);
    Navigator.of(context).pop(); // remove confirmation window
    Navigator.of(context).pop(); // remove initial entry window
    Navigator.pushReplacement(
        context, DashboardPage.route()); // Move to dashboard w/o encryption
    await settings.save();
  }

  void _attemptLogin(BuildContext context) async {
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
                      _verifyPassword(context, passwordFieldText);
                  },
                  child: const Text("Enter")
              ),
            ],
          ),
    );
  }

  void _verifyPassword(BuildContext context, String password) async  {
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
}
