import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

// Button for settings
class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Screen"),
          backgroundColor: Colors.deepPurpleAccent,
          shadowColor: Colors.orangeAccent,
        ),
        body: Container(
            color: Colors.white54,
            child: Center(
              child: GestureDetector(   // Detect if pushed
                  onTap: () {
                    Navigator.push(     // Go to settings page
                        context, MaterialPageRoute(builder: (context) => const SettingsPage())
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
            )
        )
    );
  }
}
// class ToggleThemeButton extends StatelessWidget {
//   const ToggleThemeButton({super.key });
//
//   @override
//   Widget build(BuildContext context){
//     return  AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: 25.0,
//       width: 50,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.0),
//         color: Theme.of(context).brightness == Brightness.dark
//             ? Colors.greenAccent[100]
//             : Colors.redAccent[100]?.withOpacity(0.5),
//       ),
//       child: Stack(
//         children: [
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeIn,
//             top: 3.0,
//             left: Theme.of(context).brightness == Brightness.dark
//                 ? 25.0
//                 : 0.0,
//             right: Theme.of(context).brightness == Brightness.dark
//                 ? 0.0
//                 : 25.0,
//             child: InkWell(
//                 onTap: () {
//                 },
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   transitionBuilder:
//                       (Widget child, Animation<double> animation) {
//                     return RotationTransition(
//                         turns: animation, child: child);
//                   },
//                   child: Theme.of(context).brightness == Brightness.dark
//                       ? Icon(Icons.shield_moon_outlined,
//                       color: Colors.green,
//                       size: 20.0,
//                       key: UniqueKey())
//                       : Icon(Icons.sunny,
//                       color: Colors.red,
//                       size: 20.0,
//                       key: UniqueKey()),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }