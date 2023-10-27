import 'package:app/provider/settings.dart';
import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter/material.dart';

//create welcome page class like in app example starting with stateful widget
class WelcomePage extends StatefulWidget {
  //add route for later use
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const WelcomePage());
  }

  //for now it requires a title but since the welcome page is always the welcome
  //page we could change this
  const WelcomePage({super.key});

  //overide the new state
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {

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
            //replace text btuton with container for cleaner code
            Container(
              //apply custom container properties for title
              //font length plus padding
              width: 350,
              //minimum height is aquired from fontSize from top and bottom padding
              //on edge for symmetry
              height: 35,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0))),
              //child is title text
              child: Text(
                'Pocket Therapist',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
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
              //minimum height is aquired from fontSize border radius
              height: 31,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(15.0))),
              //child is title text
              child: Text(
                'How are you "really" feeling today?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            //spacer between qoute and password field
            const Spacer(
              flex: 1,
            ),
            //to limit the text fields with we add a sized box
            SizedBox(
                width: 350,
                child:
                    //add in code block to determine what to display
                    (() {
                  //if data is initialized then open up text field
                  if (SettingsManager.wasInitialized()) {
                    //add text field for password if data is
                    return TextField(
                      //key will be called in testing
                      key: const Key('Password_Field'),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.only(
                            left: 30.0,
                            right: 30.0,
                            top: 0.0,
                            bottom: 0.0,
                          ),
                          fillColor: Theme.of(context).colorScheme.primary,
                          labelStyle: Theme.of(context).textTheme.bodyLarge,
                          labelText: "Enter Your Password"),
                    );
                    //if it is null or false then we display the start screen
                  } else {
                    //sized box  to display start button
                    return SizedBox(
                        width: 270,
                        height: 45,
                        child:
                            //start button
                            TextButton(
                          //key is called in testing
                          key: const Key("Start_Button"),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 10.0,
                            shadowColor: Theme.of(context).colorScheme.shadow,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            //add padding to shape the button
                            padding: const EdgeInsets.only(
                              left: 0.0,
                              right: 0.0,
                              top: 0.0,
                              bottom: 0.0,
                            ),
                          ),
                          //current on press event acts as if user set up database
                          onPressed: null,
                          child: Text(
                            //slightly different theme for start button
                            style: Theme.of(context).textTheme.headlineSmall,
                            'Start',
                          ),
                        ));
                  }
                }())),
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
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    //add padding to shape the button
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                    )),
                //use commented out function to test shared preferences during run time
                onPressed: null, //() {setDataPref(false);},
                child: Text(
                  //use theme from main
                  style: Theme.of(context).textTheme.bodyLarge,
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
                  //earase everything button
                  TextButton(
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    //add padding to shape the button
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                    )),
                onPressed: null,
                child: Text(
                  //copy style from texttheme in main
                  style: Theme.of(context).textTheme.bodyLarge,
                  'Erase everything',
                ),
              ),
            ),
            //spacer for after erase everything and qoute of the day
            const Spacer(
              flex: 1,
            ),
            //use a container for the qoute of the day
            Quote(),
            //spacer for after erase everything and qoute of the day
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Settings',
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        foregroundColor: Theme.of(context).colorScheme.background,
        shape: const CircleBorder(eccentricity: 1.0),
        child: const Icon(Icons.settings),
      ),
    );
  }
}
