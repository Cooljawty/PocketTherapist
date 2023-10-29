import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';
//add line for field import
import 'package:app/uiwidgets/fields.dart';
import 'package:flutter/material.dart';
//add line for shared preferences
import 'package:shared_preferences/shared_preferences.dart';

import '../uiwidgets/decorations.dart';

//create welcome page class like in app example starting with stateful widget
class WelcomePage extends StatefulWidget {
  //add route for later use
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const WelcomePage());
  }

  //for now it requires a title but since the welcome page is always the welcome
  //page we could change this
  const WelcomePage({super.key});

  //override the new state
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //add in boolean that will be used to hold the shared preference and control
  //the display
  late bool dataInit = false;
  //update from late variable to regular bool for coverage
  bool isPasswordCorrect = false;
  final TextEditingController _passwordController = TextEditingController();

  // better to have var up here than to make a local one
  SharedPreferences? _preferences;

  //add function to set shared preference
  Future setDataPref(bool setValue) async {
    //store value in shared pref
    _preferences?.setBool('DataInitialized', setValue);
    //ensure both match up
    dataInit = setValue;
    //update page after setting
    setState(() {});
  }

  //add function to retrieve stored value
  Future<bool> getDataPref() async {
    // get the instance
    _preferences = await SharedPreferences.getInstance();

    //if data ref is null create it
    if (_preferences?.getBool('DataInitialized') == null) {
      //case: new user
      //initialize shared preference
      _preferences?.setBool('DataInitialized', false);
      //ensure both match up
      dataInit = false;
    } else {
      //user has dataInitialized but no password set
      //grab preference data for password
      if (_preferences?.getString('Password') == null) {
        //no password is found/ users first time using app
        dataInit = false;
        _preferences?.setBool('DataInitialized', dataInit);
      } else if (_preferences?.getString('Password') == "") {
        //if no password is used then user chose to have no password
        isPasswordCorrect = true;
        dataInit = _preferences?.getBool('DataInitialized') ?? false;
      } else {
        //then there must be a password set and we must match it
        if (_preferences?.getString('Password') != null) {
          isPasswordCorrect = false;
          //update Data initialized in case it is false
          dataInit = true;
          _preferences?.setBool('DataInitialized', dataInit);
          dataInit = _preferences?.getBool('DataInitialized') ?? false;
        }
      }
    }
    //update page after we grab the correct value for our shared pref
    setState(() {});
    return dataInit;
  }

  //override the initial state to add in the shared preferences
  @override
  void initState() {
    //initialize boolean into shared preference or vice versa if already exist
    getDataPref();
    //run initial state of app
    super.initState();
  }

  //save the password in the text field
  void _savePassword() {
    // get the text in the box
    String password = _passwordController.text;
    if (password == "") {
      isPasswordCorrect = true;
    }
    // save the password
    _preferences?.setString('Password', password);
    //call to set dataInitialized and update state
    setDataPref(true);
    setState(() {});
  }

  //in the case of empty password we set isPasswordCorrect to true so only the
  //start button is displayed on the welcome page
  void _saveEmptyPassword() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences?.setString('Password', "");
    await setDataPref(true);
    isPasswordCorrect = true;
    setState(() {});
  }

  // erase the password in the text field
  void _erasePassword() {
    _preferences?.remove('Password');
  }

  // get the saved password
  String _getPassword() {
    // get the instance
    String? password = _preferences?.getString('Password');

    // check if null
    password ??= "password";

    // return the password
    return password;
  }

//modify the validation method to match validator type
  String? mainValidator(String? fieldContent) {
    String textField = fieldContent ?? "";
    String password = _getPassword();
    // if password matches
    if (textField == password) {
      //update isPasswordCorrect
      isPasswordCorrect = true;
      return 'Access Granted';
      //currently this works and updates the screen after the correct
      //password is inputed. Only updates after form is submitted
    } else {
      isPasswordCorrect = false;
    }
    return 'Password';
  }

  //reset preferences for testing purposes and later can be used for reseting password
  void resetPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    //delete the password if there is one
    _erasePassword();
    //remove dataInitialized
    await _preferences?.remove('DataInitialized') ?? false;
    //reInitialize the data with DataInitialized being false so we have a valid
    //new user state
    await getDataPref();
    //update widgets on screen
    setState(() {});
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
              //minimum height is acquired from fontSize border radius
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
            //spacer between quote and password field
            const Spacer(
              flex: 1,
            ),
            //to limit the text fields with we add a sized box
            SizedBox(
                width: 350,
                child:
                //add in code block to determine what to display
                (() {

                  //if data is initialized and isPassword correct is false to indicate
                  //there is a password
                  if (dataInit == true && isPasswordCorrect == false) {
                    //replace in favor of garrets password field
                    return PasswordField(
                      //key used in test case
                      key: const Key('Password_Field'),
                      hintText: "Enter Your Password",
                      //temperary validation method without encryption
                      validator: mainValidator,
                    );
                    //if it is null or false then we display the start button
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
                          onPressed: () async {
                            //check first if account exist
                            if (dataInit == false) {
                              //prompt for password set up
                              passwordPrompt();
                            } else {
                              //if the data is already initialized then user chose
                              //no password and grant entry ie navigate to dashboard
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>

                                      const DashboardPage()));

                            }
                          },
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

                key: const Key('Reset_Button'),
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
                onPressed: () async {
                  //update to delete all data preferences
                  resetPreferences();
                  //call to change the state to account creation page
                },
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
              //erase everything button
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
                  //copy style from text theme in main
                  style: Theme.of(context).textTheme.bodyLarge,
                  'Erase everything',
                ),
              ),
            ),
            //spacer for after erase everything and quote of the day
            const Spacer(
              flex: 1,
            ),
            //use a container for the quote of the day
            Quote(),
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
          Navigator.push(context, SettingsPage.route());
        },
        tooltip: 'Settings',
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        foregroundColor: Theme.of(context).colorScheme.background,
        shape: const CircleBorder(eccentricity: 1.0),
        child: const Icon(Icons.settings),
      ),
    );
  }

  Future passwordPrompt() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          title: const Text("First time user?"),
          content: const Text("Would you like to set a password?"),
          actions: [
            TextButton(
                //add key for testing
                key: const Key('Require_Password_Option'),
                onPressed: () {
                  //create situation to save password to local storage
                  Navigator.of(context).pop();
                  createPassword();
                },
                child: const Text("Yes")),
            TextButton(
                //add key for reference within code test
                key: const Key('No_Password_Option'),
                onPressed: () {
                  //save empty password
                  _saveEmptyPassword();
                  //pop dialouge window
                  Navigator.of(context).pop();
                  //go to dashboard
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardPage()));
                },
                child: const Text("No")),
          ],
        ),
      );
  //create a new prompt that prompts the user for a password and after hitting save
  //runs the save password function to save either the password written or nothing
  //if user did not write anything
  Future createPassword() => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            title: const Text("Enter your new Password"),
            actions: [
              TextField(
                //using password controller to save new password
                controller: _passwordController,
              ),
              TextButton(
                //add key for testing
                key: const Key('Save_Password'),
                onPressed: () {
                  //new password is made so update to false
                  isPasswordCorrect = false;
                  //if password is empty isPasswordCorrect will be overwritten
                  _savePassword();
                  Navigator.of(context).pop();
                  //go to dashboard
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardPage()));
                },
                child: const Text('Save Password'),
              )
            ],
          )));
}