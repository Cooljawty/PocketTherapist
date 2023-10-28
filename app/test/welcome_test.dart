import 'package:app/pages/welcome.dart';
import 'package:app/provider/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets("No password account creation", (widgetTester) async {
    await init(); // base init for settings & encryptor


  });

}
