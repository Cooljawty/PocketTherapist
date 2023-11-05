import 'package:flutter/material.dart';

class TagSettingsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const TagSettingsPage());
  }

  const TagSettingsPage({super.key});

  @override
  State<TagSettingsPage> createState() => _TagSettingsState();
}

class _TagSettingsState extends State<TagSettingsPage> {
  //eventually this taglist will need to pull the list from a save location
  List<String> tagList = [
    'Calm',
    'Centered',
    'Content',
    'Fulfilled',
    'Patient',
    'Peaceful',
    'Present',
    'Relaxed',
    'Serene',
    'Trusting',
  ];
  List<String>? compatableTagList;
  TextEditingController textController = TextEditingController();
  //delete tag function used to delete the tag from the complete list
  //and update the screen
  void deleteTag(String name) {
    tagList.remove(name);
    compatableTagList?.remove(name);
    setState(() {});
  }

  //function to add a tag to the complete list and update screen
  void addTag(String name) {
    //check for duplicates and add only unique names
    if (!tagList.contains(name)) {
      tagList.add(name);
      //declare compatable list and add new name
      compatableTagList ??= [];
      compatableTagList?.add(name);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
                List<String> nullProofTagList = [];
                //clear compatable list for each search to ensure consistency
                nullProofTagList.clear();
                compatableTagList?.clear();
                //check the full tag list for comptable tags
                for (int index = 0; index < tagList.length; index++) {
                  if (tagList[index].contains(inputText)) {
                    //add index to list of compatableTags
                    compatableTagList?.add(tagList[index]);
                    nullProofTagList.add(tagList[index]);
                  }
                }
                //update screen before return
                setState(() {});
                return;
              },
              //ideally would prompt if they would like to create tag
              onFieldSubmitted: (value) => {
                //trim off white space from both sides
                value = value.trim(),
                if (value.isNotEmpty)
                  {
                    addTag(value),
                    value = "",
                  }
              },
            ),
            SingleChildScrollView(
              child: ((() {
                //if the function returns is false then we display button to create tag
                if (!tagsExist(compatableTagList, tagList)) {
                  //if null thats our sign to return a button
                  Column finalColumn = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No Compatable Tags found: "),
                      ElevatedButton(
                          key: const Key('Create Tag'),
                          //on pressed adds the phrase in the text form field to the taglist
                          onPressed: () => addTag(textController.text),
                          child: const Text('Create Tag'))
                    ],
                  );
                  return finalColumn;
                } else {
                  List<Widget> childofColumn = [
                    const Text("List of compatable tags: ")
                  ];
                  //if comptable list is still null nothing has been searched
                  List<String> compList = compatableTagList ?? tagList;
                  for (int index = 0; index < compList.length; index++) {
                    //generate 1 row for each name in list
                    childofColumn.add(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //first child is tag
                        Text(compList[index]),
                        //second is delete button
                        TextButton(
                            key: Key('Delete ${compList[index]} Button'),
                            onPressed: () => deleteTag(compList[index]),
                            child: const Text('Delete')),
                      ],
                    ));
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
    ));
  }
}

//this function will return true if the compatable list has anything to display
//onto the screen
bool tagsExist(List<String>? compatableList, List<String> actualList) {
  //first initialize the list if it has not yet been done
  List<String> nullProofTagList = compatableList ?? [];
  //check if compatable list has been initialized and if not return the full tag list
  if (compatableList != null && nullProofTagList.isEmpty) {
    //if the list is empty then no tags are found and button will be displayed
    return false;
  }
  //either filter has results or nothing is searched yet
  return true;
}
