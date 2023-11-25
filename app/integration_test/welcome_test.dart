import 'package:app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/provider/settings.dart' as settings;

void main() async {
  setUp(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() async {
    await settings.reset();
  });

  testWidgets("Login to Account", (widgetTester) async {
    const String password = "password123@";
    const String badPassword = "password123";

    app.main();
    await widgetTester.pump();
    // This is a ripped hash from  an actual install so it should function the same everytime.
    Map<String, Object> settingsMap = {
      "configured": true,
      "theme": 0,
      "fontScale": 1.0,
      "encryption": true,
      "accent": 4289956095,
      "enc": {
        "data": "246172676f6e32696424763d3139246d3d3530303030302c743d382c703d34244b442b2b445075716463337855546b357066724a7777246b30684a376a753876563346492f56394373676c414f774343744e4c39554e3154685769616e783856646f2359486e32576a702f757166782b484a6d3a524a4a463252475a4565526b4e54455332794c6c664e6e4d522b54467876716d385832504b5639306448757143504c306c75634f752f334f6463373658366e6d236f4f787635776134424c3552762f32753a78346e5939396230374b65777133497636396f667149596759664743416e2f775479556a342b6b3575696c51726f42324571597938426e684b4d7469394b486623246172676f6e32696424763d3139246d3d3530303030302c743d382c703d3424514f65346654574346514c446e44376a6a7776374f7724346b41534432334d6e6576723268574b646b494c6530524f672b5070764d7857764338527261306f563155",
        "sig": "5e211073bf51a887aa407da84c4508d0baded525a46682fc4399bbcc4d6a07c85050d4735cd605d561590e8d2d8342be0f509d90b426a4bc8a6a6594fc8a5222"
      },
      "tags": [
        "Calm",
        "Centered",
        "Content",
        "Fulfilled",
        "Patient",
        "Peaceful",
        "Present",
        "Relaxed",
        "Serene",
        "Trusting"
      ]
    };
    settings.setMockValues(settingsMap);
    await widgetTester.pump();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    await expectLater(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pump();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert, findsOneWidget);

    Finder passwordField = find.descendant(
        of: find.byKey(const Key("Login_Password_Field")),
        matching: find.byType(TextFormField));
    await expectLater(passwordField, findsOneWidget);

// Enter password ---------------------------------------------------------------
    await widgetTester.runAsync(() async {

      await widgetTester.enterText(passwordField, badPassword);
      await widgetTester.pump();

      /// Submit the first password ( stores it )
      Finder enterPasswordButton = find.byKey(const Key('Submit_Password'));
      await widgetTester.tap(enterPasswordButton);
      await widgetTester.pump();

      Finder confirmIncorrectButton = find.byKey(const Key("Incorrect_Password"));
      await widgetTester.tap(confirmIncorrectButton);
      await widgetTester.pump();

    });
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pump();

    Finder seePasswordButton = find.byType(IconButton);
    await widgetTester.tap(seePasswordButton);
    await widgetTester.pump();
    await widgetTester.tap(seePasswordButton);
    await widgetTester.pump();

    await widgetTester.runAsync(() async {
      Finder enterPasswordButton = find.byKey(const Key('Submit_Password'));
      await widgetTester.tap(enterPasswordButton);
      await widgetTester.pump();
    });
    await widgetTester.pumpAndSettle();
    //Successful login, on dashboard
    await expectLater(find.text("Dashboard"), findsNWidgets(2));
  });

  testWidgets("No Password Account creation", (widgetTester) async {
    String password = "";
    app.main();
    await widgetTester.pump();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    await expectLater(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pump();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert, findsOneWidget);
    Finder passwordField = find.descendant(
        of: find.byKey(const Key('Enter_Password_Field')),
        matching: find.byType(TextFormField)
    );
    await expectLater(passwordField, findsOneWidget);

// Enter password ---------------------------------------------------------------
    await widgetTester.enterText(passwordField, password);
    await widgetTester.pump();

    /// Submit the first password ( stores it )
    Finder enterPasswordButton = find.byKey(const Key('Create_Password'));

// Tap enter button to create password ----------------------------------------------
    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pump();
    encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert,
        findsNWidgets(2)); // should be two alerts now, one on the other

// Find the confirm button ---------------------------------------------------------
    Finder confirmNoPasswordButton = find.text("Yes");
    await expectLater(confirmNoPasswordButton, findsOneWidget);
    await widgetTester.tap(confirmNoPasswordButton);
    await widgetTester.pumpAndSettle();

    await expectLater(find.text("Dashboard"), findsNWidgets(2));
  });

  testWidgets(
      "No Password But Then Password Account creation", (widgetTester) async {
    app.main();
    await widgetTester.pump();

    Finder startbutton = find.byKey(const Key("Start_Button"));
    await expectLater(startbutton, findsOneWidget);
    await widgetTester.tap(startbutton);
    await widgetTester.pump();

// First alert box - Enter password ---------------------------------------------[
    Finder encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert, findsOneWidget);

// Enter password ---------------------------------------------------------------
    /// Submit the first password ( stores it )
    Finder enterPasswordButton = find.byKey(const Key('Create_Password'));

// Tap enter button to create password ----------------------------------------------
    await widgetTester.tap(enterPasswordButton);
    await widgetTester.pump();
    encryptionAlert = find.byType(AlertDialog);
    await expectLater(encryptionAlert,
        findsNWidgets(2)); // should be two alerts now, one on the other

// Find the confirm button ---------------------------------------------------------
    Finder confirmNoPasswordButton = find.text("No");
    await expectLater(confirmNoPasswordButton, findsOneWidget);
    await widgetTester.tap(confirmNoPasswordButton);
    await widgetTester.pump();
  });

  testWidgets("Reset Password w/ recovery code", (widgetTester) async {
      // the recovery phrase
      String recovery = "46jDQvvpxNNsX7yb4mrg6F+e2lg=";
      // This is a ripped hash from  an actual install so it should function the same everytime.
      Map<String, Object> settingsMap = {
        "configured": true,
        "theme": 0,
        "fontScale": 1.0,
        "encryption": true,
        "accent": 4289956095,
        "enc": {
          "data": "246172676f6e32696424763d3139246d3d3530303030302c743d382c703d34244b442b2b445075716463337855546b357066724a7777246b30684a376a753876563346492f56394373676c414f774343744e4c39554e3154685769616e783856646f2359486e32576a702f757166782b484a6d3a524a4a463252475a4565526b4e54455332794c6c664e6e4d522b54467876716d385832504b5639306448757143504c306c75634f752f334f6463373658366e6d236f4f787635776134424c3552762f32753a78346e5939396230374b65777133497636396f667149596759664743416e2f775479556a342b6b3575696c51726f42324571597938426e684b4d7469394b486623246172676f6e32696424763d3139246d3d3530303030302c743d382c703d3424514f65346654574346514c446e44376a6a7776374f7724346b41534432334d6e6576723268574b646b494c6530524f672b5070764d7857764338527261306f563155",
          "sig": "5e211073bf51a887aa407da84c4508d0baded525a46682fc4399bbcc4d6a07c85050d4735cd605d561590e8d2d8342be0f509d90b426a4bc8a6a6594fc8a5222"
        },
        "tags": [
          "Calm",
          "Centered",
          "Content",
          "Fulfilled",
          "Patient",
          "Peaceful",
          "Present",
          "Relaxed",
          "Serene",
          "Trusting"
        ]
      };
      settings.setMockValues(settingsMap);

      app.main();
      await widgetTester.pump();

      do {
        await widgetTester.pump();
      }while(widgetTester.widgetList(find.byKey(const Key("Reset_Button"))).isEmpty);

            Finder resetButton = find.byKey(const Key("Reset_Button"));
      await widgetTester.tap(resetButton);
      await widgetTester.pump();
      Finder passwordResetField = find.byKey(const Key("Reset_Password_Field"));
      Finder resetPasswordbutton = find.byKey(
          const Key("Reset_Password_Button"));
      await expectLater(passwordResetField, findsOneWidget);
      await widgetTester.enterText(passwordResetField, "PotatoChips");
      await widgetTester.pump();
      await widgetTester.tap(resetPasswordbutton);
      await widgetTester.pump();
      Finder okResetPassButton = find.byKey(const Key("Fail_Pass_Reset"));
      await expectLater(okResetPassButton, findsOneWidget);
      await widgetTester.tap(okResetPassButton);
      await widgetTester.pump();
      await widgetTester.enterText(passwordResetField, recovery);
      await widgetTester.pump();
      await widgetTester.tap(resetPasswordbutton);
      await widgetTester.pump();

      okResetPassButton = find.byKey(const Key("Success_Pass_Reset"));

      do{
        await widgetTester.pump();
      }while(widgetTester.widgetList(find.byKey(const Key("Success_Pass_Reset"))).isEmpty);

      await expectLater(okResetPassButton, findsOneWidget);
      await widgetTester.tap(okResetPassButton);
      await widgetTester.pump();
      await expectLater(find.text("Encryption?"), findsOneWidget);
  });

  testWidgets("Reset Password w/ password", (widgetTester) async {
      String password = "password123@";
      // This is a ripped hash from  an actual install so it should function the same everytime.
      Map<String, Object> settingsMap = {
        "configured": true,
        "theme": 0,
        "fontScale": 1.0,
        "encryption": true,
        "accent": 4289956095,
        "enc": {
          "data": "246172676f6e32696424763d3139246d3d3530303030302c743d382c703d34244b442b2b445075716463337855546b357066724a7777246b30684a376a753876563346492f56394373676c414f774343744e4c39554e3154685769616e783856646f2359486e32576a702f757166782b484a6d3a524a4a463252475a4565526b4e54455332794c6c664e6e4d522b54467876716d385832504b5639306448757143504c306c75634f752f334f6463373658366e6d236f4f787635776134424c3552762f32753a78346e5939396230374b65777133497636396f667149596759664743416e2f775479556a342b6b3575696c51726f42324571597938426e684b4d7469394b486623246172676f6e32696424763d3139246d3d3530303030302c743d382c703d3424514f65346654574346514c446e44376a6a7776374f7724346b41534432334d6e6576723268574b646b494c6530524f672b5070764d7857764338527261306f563155",
          "sig": "5e211073bf51a887aa407da84c4508d0baded525a46682fc4399bbcc4d6a07c85050d4735cd605d561590e8d2d8342be0f509d90b426a4bc8a6a6594fc8a5222"
        },
        "tags": [
          "Calm",
          "Centered",
          "Content",
          "Fulfilled",
          "Patient",
          "Peaceful",
          "Present",
          "Relaxed",
          "Serene",
          "Trusting"
        ]
      };
      settings.setMockValues(settingsMap);

      app.main();
      await widgetTester.pump();

      do {
        await widgetTester.pump();
      }while(widgetTester.widgetList(find.byKey(const Key("Reset_Button"))).isEmpty);

      Finder resetButton = find.byKey(const Key("Reset_Button"));
      await widgetTester.tap(resetButton);
      await widgetTester.pump();
      Finder passwordResetField = find.byKey(const Key("Reset_Password_Field"));
      Finder resetPasswordbutton = find.byKey(
          const Key("Reset_Password_Button"));
      await expectLater(passwordResetField, findsOneWidget);
      await widgetTester.enterText(passwordResetField, "PotatoChips");
      await widgetTester.pump();
      await widgetTester.tap(resetPasswordbutton);
      await widgetTester.pump();
      Finder okResetPassButton = find.byKey(const Key("Fail_Pass_Reset"));
      await expectLater(okResetPassButton, findsOneWidget);
      await widgetTester.tap(okResetPassButton);
      await widgetTester.pump();
      await widgetTester.enterText(passwordResetField, password);
      await widgetTester.pump();
      await widgetTester.tap(resetPasswordbutton);

      do{
        await widgetTester.pump();
      }while(widgetTester.widgetList(find.byKey(const Key("Success_Pass_Reset"))).isEmpty);

      okResetPassButton = find.byKey(const Key("Success_Pass_Reset"));
      await expectLater(okResetPassButton, findsOneWidget);
      await widgetTester.tap(okResetPassButton);
      await widgetTester.pump();
      await expectLater(find.text("Encryption?"), findsOneWidget);
  });

}