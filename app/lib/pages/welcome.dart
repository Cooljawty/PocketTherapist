import 'package:app/uiwidgets/decorations.dart';
import 'package:flutter/material.dart';

//create welcome page class like in app example starting with stateful widget
class WelcomePage extends StatefulWidget {
  //for now it requires a title but since the welcome page is always the welcome
  //page we could change this
  const WelcomePage({super.key, required this.title});
  final String title;

  //overide the new state
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //duplicate build method from example with changes noted below
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //make app bar appear hidden but title will be in test case
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          //make the app bar invisible since we do not use it on this screen
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //add a text button with no functionality to get the round button shape
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.deepPurple,
                  //add padding to shape the button
                  padding: const EdgeInsets.only(
                    left: 120.0,
                    right: 120.0,
                    top: 0.0,
                    bottom: 0.0,
                  )),
              onPressed: null,
              child: const Text(
                style: TextStyle(color: Colors.white),
                'Pocket Therapist',
              ),
            ),
            //add image line to show logo place holder
            const Image(
              image: AssetImage('assets/logo.png'),
              height: 90.0,
              width: 90.0,
            ),
            //add another non functional text button for the qoute under the
            //photo
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 10.0,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.deepPurple,
                  //add padding to shape the button
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 0.0,
                    bottom: 0.0,
                  )),
              onPressed: null,
              child: const Text(
                style: TextStyle(color: Colors.white),
                'How are you "really" feeling today?',
              ),
            ),
            //spacer between qoute and password field
            const Spacer(
              flex: 1,
            ),
            //to limit the text fields with we add a sized box
            SizedBox(
              width: 350,
              child: //add text field for password
                  TextField(
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
                    fillColor: Colors.deepPurple,
                    labelStyle: const TextStyle(color: Colors.white),
                    labelText: "Enter Your Password"),
              ),
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
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    shadowColor: Colors.black,
                    backgroundColor: Colors.deepPurple,
                    //add padding to shape the button
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                    )),
                onPressed: null,
                child: const Text(
                  style: TextStyle(color: Colors.white),
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
                    shadowColor: Colors.black,
                    backgroundColor: Colors.deepPurple,
                    //add padding to shape the button
                    padding: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                    )),
                onPressed: null,
                child: const Text(
                  style: TextStyle(color: Colors.white),
                  'Erase everything',
                ),
              ),
            ),
            //spacer for after erase everything and qoute of the day
            const Spacer(
              flex: 1,
            ),
            //use a container for the qoute of the day
            const RandomQuoteGenerator(),
            //spacer for after erase everything and qoute of the day
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Settings',
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
        foregroundColor: Colors.grey,
        shape: CircleBorder(eccentricity: 1.0),
        child: Icon(Icons.settings),
      ),
    );
  }
}
