import 'package:app/provider/settings.dart' as prov;
import 'package:flutter/material.dart';

///Each tag can be associated to diffrent journal entries and events.
///Tags can also have an optinal color, with grey as the default.
class Tag {
	final String name;
	Color color;

	Tag({required this.name, this.color = Colors.grey});

	String getName() => name;
	Color getColor() => color;
	}

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
  List<Tag>? compatableTagList;
  TextEditingController textController = TextEditingController();

  //delete tag function used to delete the tag from the complete list
  //and update the screen
  void deleteTag(Tag tag) {
    prov.tagList.remove(tag);
    //call save
    prov.save();
    compatableTagList?.remove(tag);
    setState(() {});
  }

  //function to add a tag to the complete list and update screen
  void addTag(BuildContext context, {required String name, Color? color}) {
		String newName = name;
		Color newColor = color ?? Colors.grey;

		final List<DropdownMenuEntry<Color>> colorEntries = [];
		for (var color in ColorList.values) {
			colorEntries.add( DropdownMenuEntry<Color>(
					value: color.color, 
					label: color.name, 
					leadingIcon: Icon(Icons.circle, color: color.color)
				)
			);
		}

    //check for duplicates and add only unique names
    if (!prov.tagList.any((tag) => tag.getName() == name)) {
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
										decoration: InputDecoration(hintText: "Tag name"),
										initialValue: name,
										onChanged: (name) { newName = name; },
									),
								),
								//Tag Color
								Container(
									padding: const EdgeInsets.symmetric(vertical: 16),
									child: DropdownMenu<Color>(
										key: const Key('Tag Color Field'),
										initialSelection: color ?? Colors.grey,
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
									final newTag = Tag(name: newName, color: newColor ?? Colors.grey);
									prov.tagList.add(newTag);
									//call save
									prov.save();
									//declare compatible list and add new name
									compatableTagList ??= [];
									compatableTagList?.add(newTag);
									
									//Update search bar with new name
									textController.value = TextEditingValue(text: newName); 

									Navigator.pop(context);
								}
							),
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

    setState((){});
  }

	//Display tags as a row of widgets
	Widget _displayTag(int index, List<Tag> compList) {
		List<Widget> tagRow = [
			//first child is tag
			Text(compList[index].name),
			//second is delete button
			TextButton(
					key: Key('Delete ${compList[index].name} Button'),
					onPressed: () => deleteTag(compList[index]),
					child: const Text('Delete')),
		];

		//If opend from NewEntry page, add a selection button
		if (widget.selectedTags != null) { 
			tagRow.insert(0, Checkbox(
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
        body: SafeArea(
					//Ensure that selected tags are returned after quitting
					child: WillPopScope(
					onWillPop: () async {
						Navigator.pop(context, widget.selectedTags);
						return false;
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
                    //the validator will update the compatable tag list to a state
                    //that will be used in the tagsExist function to build the display
                    if (inputText.isEmpty) {
                      //no input found yet so we update the compatable list to null and prompt user
                      compatableTagList = null;
                      //update list to screen
                      setState(() {});
                      return;
                    }
                    //input text has something so we move onto the search
                    compatableTagList ??= [];
                    List<Tag> nullProofTagList = [];
                    //clear compatable list for each search to ensure consistency
                    nullProofTagList.clear();
                    compatableTagList?.clear();
                    //check the full tag list for comptable tags
                    for (int index = 0; index < prov.tagList.length; index++) {
                      if (prov.tagList[index].getName().contains(inputText)) {
                        //add index to list of compatableTags
                        compatableTagList?.add(prov.tagList[index]);
                        nullProofTagList.add(prov.tagList[index]);
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
                    if (!tagsExist(compatableTagList, prov.tagList)) {
                      //if null thats our sign to return a button
                      Column finalColumn = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("No Compatable Tags found: "),
                          ElevatedButton(
                              key: const Key('Create Tag'),
                              //on pressed adds the phrase in the text form field to the taglist
                              onPressed: () => addTag(context, name: textController.text),
                              child: const Text('Create Tag'))
                        ],
                      );
                      return finalColumn;
                    } else {
                      List<Widget> childofColumn = [
                        const Text("List of compatable tags: ")
                      ];
                      //if comptable list is still null nothing has been searched
                      List<Tag> compList = compatableTagList ?? prov.tagList;
                      for (int index = 0; index < compList.length; index++) {
                        //generate 1 row for each name in list
                        childofColumn.add( _displayTag(index, compList) );
                      }
											//Always add the add tags button if comming from new entry page
											if (widget.selectedTags != null) { 
												childofColumn.add(ElevatedButton(
														key: const Key('Create Tag'),
														//on pressed adds the phrase in the text form field to the taglist
														onPressed: () => addTag(context, name: textController.text),
														child: const Text('Create Tag')
													)
												);
											}
                      //final column starts will text wigdet displayed
                      Column finalColumn = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: childofColumn);
                      return finalColumn;
                    }
                  })()),
                ),
              ],
            ),
          ),
        ),
				),
			);
  }

}

//this function will return true if the compatable list has anything to display
//onto the screen
bool tagsExist(List<Tag>? compatableList, List<Tag> actualList) {
  //first initialize the list if it has not yet been done
  List<Tag> nullProofTagList = compatableList ?? [];
  //check if compatable list has been initialized and if not return the full tag list
  if (compatableList != null && nullProofTagList.isEmpty) {
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
