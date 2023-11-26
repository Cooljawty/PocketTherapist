import 'dart:ui';

import 'package:app/provider/settings.dart' as settings;
import 'package:flutter/material.dart';
import 'package:app/helper/classes.dart';

import '../provider/theme_settings.dart';
import '../uiwidgets/decorations.dart';

///Each tag can be associated to different journal entries and events.
///Tags can also have an optional color, with grey as the default.

class TagSettingsPage extends StatefulWidget {
  final List<Tag>? selectedTags;

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const TagSettingsPage());
  }

  const TagSettingsPage({super.key, this.selectedTags});

  @override
  State<TagSettingsPage> createState() => _TagSettingsState();
}

class _TagSettingsState extends State<TagSettingsPage> {
  List<Tag>? compatibleTagList;
  TextEditingController textController = TextEditingController();

  //delete tag function used to delete the tag from the complete list
  //and update the screen
  void deleteTag(Tag tag) {
    settings.tagList.remove(tag);
    //call save
    settings.save();
    compatibleTagList?.remove(tag);
    setState(() {});
  }

  //function to add a tag to the complete list and update screen
  void addTag(BuildContext context,
      {required String name, Color color = Colors.grey}) {
    String newName = name;
    Color newColor = color;

    final List<DropdownMenuEntry<Color>> colorEntries = [];
    for (var color in ColorList.values) {
      colorEntries.add(DropdownMenuEntry<Color>(
          value: color.color,
          label: color.name,
          leadingIcon: Icon(Icons.circle, color: color.color)));
    }

    //check for duplicates and add only unique names
    if (!settings.tagList.any((tag) => (tag).name == name)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create a New Tag'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Tag name
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    key: const Key('Tag Name Field'),
                    decoration: const InputDecoration(hintText: "Tag name"),
                    initialValue: name,
                    onChanged: (name) {
                      newName = name;
                    },
                  ),
                ),
                //Tag Color
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: DropdownMenu<Color>(
                    key: const Key('Tag Color Field'),
                    initialSelection: color,
                    dropdownMenuEntries: colorEntries,
                    //Show 5 colors at a time
                    menuHeight: 4 * 50.0,
                    onSelected: (color) => setState(() => newColor = color!),
                  ),
                ),
              ],
            ),
            //Conformation buttons
            actions: <Widget>[
              TextButton(
                  key: const Key('Save New Tag Button'),
                  child: const Text('Save'),
                  onPressed: () {
                    final newTag = Tag(name: newName, color: newColor);
                    settings.tagList.add(newTag);
                    //call save
                    settings.save();
                    //declare compatible list and add new name
                    compatibleTagList ??= [];
                    compatibleTagList?.add(newTag);

                    //Update search bar with new name
                    textController.value = TextEditingValue(text: newName);

                    Navigator.pop(context);
                  }),
              TextButton(
                key: const Key('Cancel New Tag Button'),
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      );
    }

    setState(() {});
  }

  //Display tags as a row of widgets
  Widget _displayTag(int index, List<Tag> compList) {
    List<Widget> tagRow = [
      Stack(
          alignment: Alignment.center,
          children: [
        Container(
          decoration: BoxDecoration(
            color: darkenColor(
                    settings.getCurrentTheme().colorScheme.secondary, .1)
                .withAlpha(90),
          ),
          width: MediaQuery.of(context).size.width,
          height: kTextTabBarHeight,
          //color: settings.getCurrentTheme().colorScheme.background,
        ),
        // First child is tag
        // Size box and center to align tags and delete button
        Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
                width: 100,
                child: Center(
                    child: Text(compList[index].name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))),

            //second is delete button
            TextButton(
                key: Key('Delete ${compList[index].name} Button'),
                onPressed: () => deleteTag(compList[index]),
                child: Text('Delete',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ],
        )
      ])
    ];

    //If opened from NewEntry page, add a selection button
    if (widget.selectedTags != null) {
      tagRow.insert(
          0,
          Checkbox(
            key: Key('Select ${compList[index].name} Button'),
            value: widget.selectedTags!.any((tag) => tag == compList[index]),
            onChanged: (bool? selected) {
              setState(() {
                if (selected!) {
                  widget.selectedTags!.add(compList[index]);
                } else {
                  widget.selectedTags!.remove(compList[index]);
                }
              });
            },
          ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tagRow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar for back button
        appBar: AppBar(),
        body: Stack(
					children: [
          // Stripe in the background
          Transform.translate(
              offset: Offset(
                  0, -(MediaQuery.of(context).padding.top + kToolbarHeight)
							),
              // This is not const, it changes with theme, don't set it to be const
              // no matter how much the flutter gods beg
              // ignore: prefer_const_constructors
              child: StripeBackground()
					),

          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )
					),

          SafeArea(
            //Ensure that selected tags are returned after quitting
            // WillPopScope is deprecated, use pops cope instead
            child: PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                if (didPop) {
                  return;
                }
                Navigator.pop(context, widget.selectedTags);
              },
              child: SingleChildScrollView(
                //create column that will go on to contain the tag list and the search bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: textController,
                      key: const Key('Tag Search Bar'),
                      onChanged: (inputText) {
                        //the validator will update the compatible tag list to a state
                        //that will be used in the tagsExist function to build the display
                        if (inputText.isEmpty) {
                          //no input found yet so we update the compatible list to null and prompt user
                          compatibleTagList = null;
                          //update list to screen
                          setState(() {});
                          return;
                        }
                        //input text has something so we move onto the search
                        compatibleTagList ??= [];
                        List<Tag> nullProofTagList = [];
                        //clear compatible list for each search to ensure consistency
                        nullProofTagList.clear();
                        compatibleTagList?.clear();
                        //check the full tag list for compatible tags
                        for (int index = 0;
                            index < settings.tagList.length;
                            index++) {
                          if (settings.tagList[index].name
                              .contains(inputText)) {
                            //add index to list of compatibleTags
                            compatibleTagList?.add(settings.tagList[index]);
                            nullProofTagList.add(settings.tagList[index]);
                          }
                        }
                        //update screen before return
                        setState(() {});
                        return;
                      },
                      //ideally would prompt if they would like to create tag
                      onFieldSubmitted: (value) {
                        //trim off white space from both sides
                        value = value.trim();
                        if (value.isNotEmpty) {
                          addTag(context, name: value);
                          value = "";
                        }
                      },
                    ),
                    SingleChildScrollView(
                      child: ((() {
                        //if the function returns is false then we display button to create tag
                        if (!tagsExist(compatibleTagList, settings.tagList)) {
                          //if null that's our sign to return a button
                          Column finalColumn = Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("No Compatible Tags found: "),
                              ElevatedButton(
                                  key: const Key('Create Tag'),
                                  //on pressed adds the phrase in the text form field to the tag list
                                  onPressed: () => addTag(context,
                                      name: textController.text),
                                  child: const Text('Create Tag'))
                            ],
                          );
                          return finalColumn;
                        } else {
                          List<Widget> childOfColumn = [
                            const Text("List of compatible tags: ")
                          ];
                          //if compatible list is still null nothing has been searched
                          List<Tag> compList =
                              compatibleTagList ?? settings.tagList;
                          for (int index = 0;
                              index < compList.length;
                              index++) {
                            //generate 1 row for each name in list
                            childOfColumn.add(_displayTag(index, compList));
                          }
                          //Always add the add tags button if coming from new entry page
                          if (widget.selectedTags != null) {
                            childOfColumn.add(ElevatedButton(
                                key: const Key('Create Tag'),
                                //on pressed adds the phrase in the text form field to the tag list
                                onPressed: () =>
                                    addTag(context, name: textController.text),
                                child: const Text('Create Tag')));
                          }
                          //final column starts will text widget displayed
                          Column finalColumn = Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: childOfColumn);
                          return finalColumn;
                        }
                      })()),
                    ),
                  ],
                ),
              ),
            ),
          ),
				],
			),
		);
  }
}

//this function will return true if the compatible list has anything to display
//onto the screen
bool tagsExist(List<Tag>? compatibleList, List<Tag> actualList) {
  //first initialize the list if it has not yet been done
  List<Tag> nullProofTagList = compatibleList ?? [];
  //check if compatible list has been initialized and if not return the full tag list
  if (compatibleList != null && nullProofTagList.isEmpty) {
    //if the list is empty then no tags are found and button will be displayed
    return false;
  }
  //either filter has results or nothing is searched yet
  return true;
}

enum ColorList {
  red(name: "Red", color: Colors.red),
  pink(name: "Pink", color: Colors.pink),
  purple(name: "Purple", color: Colors.purple),
  deepPurple(name: "Deep Purple", color: Colors.deepPurple),
  indigo(name: "Indigo", color: Colors.indigo),
  blue(name: "Blue", color: Colors.blue),
  lightBlue(name: "Light Blue", color: Colors.lightBlue),
  cyan(name: "Cyan", color: Colors.cyan),
  teal(name: "Teal", color: Colors.teal),
  green(name: "Green", color: Colors.green),
  lightGreen(name: "Light Green", color: Colors.lightGreen),
  lime(name: "Lime", color: Colors.lime),
  yellow(name: "Yellow", color: Colors.yellow),
  amber(name: "Amber", color: Colors.amber),
  orange(name: "Orange", color: Colors.orange),
  deepOrange(name: "Deep Orange", color: Colors.deepOrange),
  brown(name: "Brown", color: Colors.brown),
  grey(name: "Grey", color: Colors.grey);

  const ColorList({required this.name, required this.color});
  final String name;
  final Color color;
}
