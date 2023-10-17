import 'package:app/pages/dashboard.dart';
import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';

//create intro page class extending the stateful widget class
class IntroPage extends StatefulWidget {
  //add page route
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const IntroPage());
  }

  //this constructor should only require the key
  const IntroPage({super.key});
  //overide the new state
  @override
  State<IntroPage> createState() => _IntroPageState();
}

//declare the intro page state
class _IntroPageState extends State<IntroPage> {
  //duplicate build method from example with changes noted below
  @override
  Widget build(BuildContext context) {
    //we will use a scaffold to draw the intro page
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      //to match the first image in the design doc I choose to draw the logo,
      //title and present the start button below. To achieve this we will use
      //a column within a centered box for added color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //add blank space for so the image is closer to being centered
            const Spacer(
              flex: 75,
            ),
            //add in logo for intro page
            const Image(
              image: AssetImage('assets/logo.png'),
              width: 350.0,
            ),

            //add a container for the text for title
            Container(
              //apply custom container properties for title
              //font length plus padding
              width: 360,
              //minimum height is aquired from fontSize from top and bottom padding
              //on edge for symmetry
              height: 60,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 3.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0))),
              //child is title text
              child: const Text(
                "Pocket Therapist",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.black,
                ),
              ),
            ),
            //add spacer between title and get started button
            const Spacer(
              flex: 5,
            ),
            //using sized box for text button sizing
            //sizing is aproximately 75% size of title
            SizedBox(
              width: 270,
              height: 45,
              child:
                  //get started button
                  TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 3.0,
                      )),
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
                //key will be used for identification in test case
                key: const Key("Start"),
                //current on press event is null but functionality will be added
                onPressed: () {
                  skipTutorialPrompt();
                },
                child: const Text(
                  style: TextStyle(
                    color: Colors.white,
                    //75% of title font size
                    fontSize: 30.0,
                  ),
                  'Get Started',
                ),
              ),
            ),
            //add final spacer so get started button has space between bottom of screen
            const Spacer(
              flex: 50,
            ),
          ],
        ),
      ),
    );
  }

  //create function for dialog box for option to skip tutorial
  Future skipTutorialPrompt() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.blueAccent,
          //simple title to offer tutorial
          title: const Text(
            "Would you like to start the tutorial?",
            //align text
            textAlign: TextAlign.center,
          ),
          //align buttons to center
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              //key used for distinction in test case
              key: const Key("Start_Tutorial"),
              //tutorial should start but for it will lead to the dashboard page
              onPressed: () {
                //event should be changed in further edits for route of tutorial
                Navigator.of(context).pushReplacement(DashboardPage.route());
              },
              //style for button to add some distinction
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 3.0,
                    )),
                elevation: 10.0,
                shadowColor: Colors.black,
                backgroundColor: Colors.blue,
              ),
              //text for yes button
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              //add key for test case
              key: const Key("Start_Intro"),
              //skip to Welcome page for start fresh button
              onPressed: () {
                //on skip we go to the welcome page for account creation
                Navigator.of(context).pushReplacement(WelcomePage.route());
              },
              //add style
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 3.0,
                    )),
                elevation: 10.0,
                shadowColor: Colors.black,
                backgroundColor: Colors.blue,
              ),
              //text for skip tutorial
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
