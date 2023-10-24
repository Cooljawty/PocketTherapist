import 'package:app/pages/dashboard.dart';
import 'package:app/pages/settings.dart';
//add line for field import
import 'package:app/uiwidgets/fields.dart';
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

  //override the new state
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  //add in boolean that will be used to hold the shared preference and control
  //the display
  late bool dataInit = false;
  late bool isPasswordCorrect = false;
  late bool isSetting = false;
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
      print('adding DataInitialized to local');
      //store value in shared pref
      _preferences?.setBool('DataInitialized', false);
      //ensure both match up
      dataInit = false;
    } else {
      //grab preference data for password
      if (_preferences?.getString('Password') == null) {
        //if no password is found then user chose to have no password
        print('no Password Found');
        isPasswordCorrect = true;
      } else {
        print('pulling Password from local');
        //then there must be a password set and we must match it
        isPasswordCorrect = false;
      }
      print('pulling DataInitialized from local');
      print('current data in preferences is');
      print(_preferences?.getKeys());
      dataInit = _preferences?.getBool('DataInitialized') ?? false;
    }
    //update page after we grab the correct value for our shared pref
    setState(() {});
    //_savePassword;
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

    // save the password
    _preferences?.setString('Password', password);
  }

  // erase the password in the text field
  void _erasePassword() {
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

  void _checkPassword() async {
    String textField = _passwordController.text;
//modify the validation method to match validator type
  String? mainValidator(String? fieldContent) {
    String textField = fieldContent ?? "";
    String password = _getPassword();

    // if password matches
    if (textField == password) {
      //update isPasswordCorrect
      isPasswordCorrect = true;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DashboardPage()));
      return "You may enter";
    } else {
      isPasswordCorrect = false;
      return "You may not enter";
    }
  }

  //reset preferences for testing purposes
  void resetPreferences() async {
    bool allDeleted = false;
    print('initial keys after erasure');
    print(_preferences?.getKeys());
    _preferences = await SharedPreferences.getInstance();
    allDeleted = await _preferences?.remove('Password') ?? false;
    if (!allDeleted) {
      print("failed to delete password");
    }
    allDeleted = await _preferences?.remove('DataInitialized') ?? false;
    if (!allDeleted) {
      print("failed to delete dataInitialized");
    }
    print('final keys after erasure');
    print(_preferences?.getKeys());
    await getDataPref();
    print('final keys after get DataPref');
    print(_preferences?.getKeys());
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
                    //add text field for password if data is
                    return PasswordField(
                      key: const Key('Password_Field'),
                      hintText: "Enter Your Password",
                      //temperary validation method will just check if values are equal
                      validator: mainValidator,
                    );
                    /*TextFormField(
                      //key will be called in testing
                      key: const Key('Password_Field'),
                      controller: _passwordController,
                      obscureText: true,
                      onFieldSubmitted: (value) {
                        if (isSetting) {
                          _savePassword();
                          isSetting = false;
                        }
                        _checkPassword();
                        if (isPasswordCorrect) {
                          // go to dashboard
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardPage()));
                        } else {
                          // clear text field
                          _passwordController.text = "";
                        }
                      },
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
                    );*/
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
                          onPressed: () async {
                            //check first if account exist
                            if (dataInit == false) {
                              //update the data preference to be true
                              await setDataPref(true);
                              //prompt for password set up
                              passwordPrompt();
                            } else {
                              //if the data is already initialized then user chose
                              //no password and grant entry navigate to dashboard
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
                }, //() {setDataPref(false);},
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
            Container(
              width: 350,
              height: 240,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 20.0),
                      )),
                  //extra container to hold the quote
                  Container(
                    width: 310,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
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

  Future passwordPrompt() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("First time user?"),
          content: const Text("Would you like to set a password?"),
          actions: [
            TextButton(
                onPressed: () {
                  isSetting = true;
                  isPasswordCorrect = false;
                  _savePassword();
                  Navigator.of(context).pop();
                },
                child: const Text("Yes")),
            TextButton(
                onPressed: () {
                  isSetting = true;
                  isPasswordCorrect = true;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardPage()));
                },
                child: const Text("No")),
          ],
        ),
      );
}
