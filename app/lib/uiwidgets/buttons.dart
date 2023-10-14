import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key });

  @override
  Widget build(BuildContext context){
    return  AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 25.0,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.greenAccent[100]
            : Colors.redAccent[100]?.withOpacity(0.5),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            top: 3.0,
            left: Theme.of(context).brightness == Brightness.dark
                ? 25.0
                : 0.0,
            right: Theme.of(context).brightness == Brightness.dark
                ? 0.0
                : 25.0,
            child: InkWell(
                onTap: SettingsManager.toggleDarkMode,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return RotationTransition(
                        turns: animation, child: child);
                  },
                  child: Theme.of(context).brightness == Brightness.dark
                      ? Icon(Icons.shield_moon_outlined,
                      color: Colors.green,
                      size: 20.0,
                      key: UniqueKey())
                      : Icon(Icons.sunny,
                      color: Colors.red,
                      size: 20.0,
                      key: UniqueKey()),
                )),
          ),
        ],
      ),
    );
  }
}