import 'package:file_picker/file_picker.dart';


/// User picks a file, and once picked can read it
/// After database, deserialize data in the file to be used
void loadFile() async {
  await FilePicker.platform.pickFiles();
}

