import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SettingsManager extends ChangeNotifier {

    static ThemeMode _currentMode = SchedulerBinding.instance.platformDispatcher
        .platformBrightness == Brightness.light ? ThemeMode.dark : ThemeMode.light;

    // This will be chhagned to load and parse the settings.yml file with dart.yml
    static Future<Map<String, Object>> loadSettings([String fileName= "settings.yml"]) async {
      return Future.delayed(
            const Duration(seconds: 5),
          () => {"This": 0}
      );
    }

    static void toggleDarkMode() =>
      _currentMode = (_currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

    bool isDarkmode() => (_currentMode == ThemeMode.dark);
}
