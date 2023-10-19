
class SettingsManager extends ChangeNotifier {

    // This will be changed to load and parse the settings.yml file with dart.yml
    static Future<void> loadSettings([String fileName= "settings.yml"]) {
      return Future.delayed (
        const Duration(seconds: 4),
          () => {"This": -1}
      );
    }

}
