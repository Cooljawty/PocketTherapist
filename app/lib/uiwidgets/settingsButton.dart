import 'package:flutter/material.dart';
import 'package:app/pages/settings.dart';

// Button for settings
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Container(
            color: Colors.white54,
              child: GestureDetector(   // Detect if pushed
                  onTap: () {
                    Navigator.push(     // Go to settings page
                        context, SettingsPage.route()
                    );
                  },
                  child: Container(     // Decoration
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.deepPurpleAccent,
                          spreadRadius: 3,
                          blurRadius: 13,
                          offset: Offset(5, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text("Settings",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)
                      ),
                    ),
                  )
              ),
        );
  }
}

// // Settings Page and Back button
// class Settings extends StatelessWidget {
//   const Settings({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(   // Contains the back button
//         title: const Text("Settings"),
//         backgroundColor: Colors.deepPurpleAccent,
//         shadowColor: Colors.orangeAccent,
//       ),
//     );
//   }
// }