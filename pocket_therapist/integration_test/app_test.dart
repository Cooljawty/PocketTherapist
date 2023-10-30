import 'package:pocket_therapist/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pocket_therapist/provider/settings.dart' as settings;


void main() {


  testWidgets("No Password Sign-in", (widgetTester) async {
    settings.setMockValues({
      settings.encryptionToggleKey: false,
      settings.configuredKey: true,
    });

    await widgetTester.pumpWidget(const RootApp());
    await widgetTester.pumpAndSettle();


  });

}