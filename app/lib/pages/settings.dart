import 'dart:ui';
import 'package:app/helper/file_manager.dart';
import 'package:app/helper/classes.dart';
import 'package:app/uiwidgets/buttons.dart';
import 'package:app/uiwidgets/decorations.dart';
import 'package:provider/provider.dart';
import 'package:app/provider/theme_settings.dart';
import 'package:app/provider/settings.dart' as settings;
import 'package:app/pages/settings_tag.dart';

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final List<Tag>? existingTags;

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
  }

  const SettingsPage({super.key, this.existingTags});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

bool encryption = false;

class _SettingsPageState extends State<SettingsPage> {
  // Drop down menu items
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeSettings>(context);
    List<String> themeStrings = ['Dark', 'Light'];
    String? chosenTheme = provider.theme == ThemeSettings.lightTheme ? 'Light' : 'Dark';
    String directory = settings.getVaultFolder();
    directory = settings.getVaultFolder().substring(directory.length - 22, directory.length);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // Settings title
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
        ),

        // Stack to make background and foreground
        body: Stack(children: [
          // Stripe in the background
          Transform.translate(
              offset: Offset(0, -(MediaQuery.of(context).padding.top + kToolbarHeight)),
              // This is not const, it changes with theme, don't set it to be const
              // no matter how much the flutter gods beg
              child: StripeBackground()),

          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )
          ),

          // Intractable Foreground
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Create a drop down menu to choose a theme
                SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    child: DropdownButtonFormField<String>(
                      //dropdownColor: ,
                      key: const ValueKey('StyleDropDown'),
                      decoration: InputDecoration(
                          // Add icons based on theme
                          prefixIcon: Transform.rotate(
                              angle: .5,
                              child: Icon(
                                chosenTheme == 'Dark'
                                    ? Icons.brightness_2
                                    : Icons.brightness_5_outlined,
                                color: darkenColor(
                                    settings
                                        .getCurrentTheme()
                                        .colorScheme
                                        .secondary,
                                    .1),
                                size: 30,
                              ))),
                      borderRadius: BorderRadius.circular(10.0),

                      // Set up the dropdown menu items
                      value: chosenTheme,
                      items: themeStrings
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                // style: const TextStyle(color: Colors.black),
                              )))
                          .toList(),

                      // if changed set the new theme
                      onChanged: (item) => setState(() {
                        chosenTheme = item;
                        provider.changeTheme(chosenTheme!);
                      }),
                    )),

                // Edit emotions list button
                StandardElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Edit Emotion List',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                        Icon(Icons.arrow_forward_ios,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ],
                    )),

                // Edit Tag list button
                StandardElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          // Go to settings page
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TagSettingsPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Edit Tag List',
                                style: Theme.of(context).textTheme.bodyLarge)),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ],
                    )),

                StandardElevatedButton(
                    onPressed: loadFile,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Open Vault File',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                        Text(directory,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    )),

                // Erase everything
                StandardElevatedButton(
                    key: const Key("Erase_Button"),
                    onPressed: () =>
                        settings.handleResetEverythingPress(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Erase Everything',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error
                                          .withRed(255),
                                    ))),
                        Icon(
                          Icons.delete_forever_rounded,
                          color:
                              Theme.of(context).colorScheme.error.withRed(255),
                        ),
                      ],
                    )),

                // Enable/Disable encryption Button
                Visibility(
                  visible: true,
                  maintainState: true,
                  // visible: settings.isConfigured(),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: darkenColor(
                                  settings
                                      .getCurrentTheme()
                                      .colorScheme
                                      .secondary,
                                  .1)
                              .withAlpha(200),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: kTextTabBarHeight,
                        //color: settings.getCurrentTheme().colorScheme.background,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Enable/Disable Encryption',
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                          Switch(
                            splashRadius: 50.0,
                            value: encryption,
                            onChanged: (value) =>
                                setState(() => encryption = value),
                            // (value) => setState(() =>
                            // settings.setEncryptionStatus(value)
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
