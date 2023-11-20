import 'package:flutter/material.dart';
import 'package:app/provider/theme_settings.dart';


/// Button that can do something with an elevation component
class StandardElevatedButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double elevation = 20.0;
  const StandardElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color shadowColor = Theme.of(context).colorScheme.shadow;
    Color backgroundColor = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: 350,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            inherit: true,
            fontSize: 16,
          ),
          elevation: elevation,
          shadowColor: shadowColor,
          backgroundColor: backgroundColor,
            side: BorderSide(
                color: darkenColor(Theme.of(context).colorScheme.primary, .1),
                width: 3
            ),
        ),
        child: child,
      )
    );
  }
}
