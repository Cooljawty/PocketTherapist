import 'package:flutter/material.dart';
//add line for shared preferences
import 'package:shared_preferences/shared_preferences.dart';

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

class _WelcomePageState extends State<WelcomePage> {
  //add in boolean that will be used to hold the shared preference
  bool _dataInit = false;

  //add in function to retrieve/initialize shared preference bool value
  Future isInitialized() async {
    //declare local shared preference by waiting for global shared reference
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //update values accordingly
    setState(() {
      //first consider if value is already present and if not create it
      if (prefs.getBool('DataInitialized') == null) {
        prefs.setBool('DataInitilized', false);
      }
      //set the boolean already declared or false if still null
      _dataInit = prefs.getBool('DataInitialized') ?? false;
    });
  }

  //add one more function for assigning shared pref value for testing
  //specifically this function is called to change the bool value after the start
  //button is hit
  Future setDataValue() async {
    //grab shared preference like before
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //set to the same as the boolean dataInit to ensure both values are updated
    setState(() {
      //set the shared preference to match the local variable
      prefs.setBool('DataInitialized', _dataInit);
    });
  }

  //overide the initial state to add in the shared preferences
  @override
  void initState() {
    //run initial state of app
    super.initState();
    //run to initialize the shared preference used
    isInitialized();
    //sync up data values
    setDataValue();
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
              decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              //child is title text
              child: const Text(
                'Pocket Therapist',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            //add image line to show logo place holder
            const Image(
              image: AssetImage('assets/logo.png'),
              width: 100.0,
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
              decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              //child is title text
              child: const Text(
                'How are you "really" feeling today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    //14 by default
                    fontSize: 16),
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
                  if (_dataInit) {
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
                          fillColor: Colors.deepPurple,
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: "Enter Your Password"),
                    );
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
                            shadowColor: Colors.black,
                            backgroundColor: Colors.deepPurple,
                            //add padding to shape the button
                            padding: const EdgeInsets.only(
                              left: 0.0,
                              right: 0.0,
                              top: 0.0,
                              bottom: 0.0,
                            ),
                          ),
                          //current on press event acts as if user set up database
                          onPressed: () {
                            //set DataInitialized to true and see if password field pops up
                            _dataInit = true;
                            setDataValue();
                          },
                          child: const Text(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
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
            Container(
              width: 350,
              height: 240,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Column(
                children: <Widget>[
                  const Align(
                      alignment: Alignment.topLeft,
                      widthFactor: 2,
                      child: Text(
                        "Qoute of the Day:",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                  //extra container to hold the qoute
                  Container(
                    width: 310,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 3.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0))),
                    //now we only need a text widget for qoute
                    child: const Text(
                      //qoute from app
                      "''Is God willing to prevent evil, but not able? Then he is not omnipotent. Is he able, but not willing? Then he is Malevolent. Is he both able and willing? Then whence cometh evil? Is he neither able nor willing? Then why call him God?''",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const TextButton(onPressed: null, child: Text("New Qoute")),
                ],
              ),
            ),
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
