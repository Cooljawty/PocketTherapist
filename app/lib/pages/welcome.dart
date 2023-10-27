import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';
import 'package:app/provider/encryptor.dart';
//add line for field import
import 'package:app/uiwidgets/fields.dart';
import 'package:flutter/material.dart';
//add line for shared preferences
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/provider/settings.dart' as settings;

//create welcome page class like in app example starting with stateful widget
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  //duplicate build method from example with changes noted below
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //remove app bar entirely since it is not yet used
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //add spacer widget for the top of the page
            const Spacer(
              flex: 10,
            ),
            //replace text button with container for cleaner code
            Container(
              //apply custom container properties for title
              //font length plus padding
              width: 350,
              //minimum height is acquired from fontSize from top and bottom padding
              //on edge for symmetry
              height: 35,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0))),
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

            // add in expanded widget to create a dynamic image size and so
            //test cases pass
            const Expanded(
              flex: 40,
              //add image line to show logo place holder
              child: Image(
                image: AssetImage('assets/logo.png'),
                width: 240.0,
              ),
            ),
            //add another container instead of button for the welcome text
            Container(
              //apply custom container properties for title
              //font length plus padding
              width: 280,
              //minimum height is acquired from fontSize border radius
              height: 31,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0))),
              //child is title text
              child: Text(
                'How are you "really" feeling today?',
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),
            //spacer between quote and password field
            const Spacer(
              flex: 1,
            ),
            //to limit the text fields with we add a sized box
            SizedBox(
              width: 350,
              child: SizedBox(
                  key: const Key('buildNoPassword'),
                  width: 270,
                  height: 45,
                  child: TextButton(
                    key: const Key("Start_Button"),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10.0,
                    ),
                    onPressed: () => handleStartPress(context),
                    child: const Text(
                      'Start',
                    ),
                  )),
              //add in code block to determine what to display
            ),
            //for spacing between password field and reset password add a spacer widget
            const Spacer(
              flex: 1,
            ),
            //using sized box for standardized sizing
            SizedBox(
              width: 350,
              height: 60,
              child:
              //reset password button
              TextButton(
                key: const Key('Reset_Button'),
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .shadow,
                    backgroundColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    //add padding to shape the button
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                    )),
                //use commented out function to test shared preferences during run time
                onPressed: () async {
                  //update to delete all data preferences
                  await settings.reset();
                  //call to change the state to account creation page
                },
                child: Text(
                  //use theme from main
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  'Reset Password',
                ),
              ),
            ),
            //spacer between reset and erase everything
            const Spacer(
              flex: 1,
            ),
            //add sized box button for erase everything
            SizedBox(
              width: 350,
              height: 60,
              child:
              //erase everything button
              TextButton(
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    shadowColor: Theme
                        .of(context)
                        .colorScheme
                        .shadow,
                    backgroundColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    //add padding to shape the button
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                    )),
                onPressed: null,
                child: Text(
                  //copy style from text theme in main
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge,
                  'Erase everything',
                ),
              ),
            ),
            //spacer for after erase everything and quote of the day
            const Spacer(
              flex: 1,
            ),
            //use a container for the quote of the day
            Container(
              width: 350,
              height: 240,
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
            const Spacer(
              flex: 1,
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

  void handleStartPress(BuildContext context) async {
    if (!settings.wasInitialized()) {
      if(settings.isEncryptionEnabled()){
        String passwordFieldText = "";
        await showDialog(
          context: context,
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
              TextButton(
                //add key for testing
                  key: const Key('Require_Password_Option'),
                  onPressed: () async {
                    //create situation to save password to local storage
                    if(passwordFieldText.isNotEmpty) {
                      if(validatePassword(passwordFieldText)) {
                        Navigator.of(context).pop();
                      } else {
                        await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Theme.of(context).colorScheme.onBackground,
                              title: const Text("Incorrect Password"),
                              actions: [TextButton(onPressed: Navigator.of(context).pop, child: const Text("Ok"))],
                            ));
                      }
                    }
                  },
                  child: const Text("Enter")),
            ],
          ),
        );
      } else {

      }
    } else {
      // Password not set, but initialized.
      Navigator.pushReplacement(
          context,
          DashboardPage.route());
    }
  }

}





