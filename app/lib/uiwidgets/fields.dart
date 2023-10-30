import 'package:app/provider/encryptor.dart' as encryptor;
import 'package:flutter/material.dart';

/// This is used as a password field, but can be used for any generic secrets
/// It supports hintText from the TextFormField widget, and will display
/// what you provide inside of the field
///
/// Use the validator to provide validation to your field, this is required
/// and returns null if valid.
class ControlledTextField extends StatefulWidget {
  final String hintText;
  final String? Function(String?) validator;
  const ControlledTextField({
        super.key, 
        this.hintText = "Password", 
        this.validator = encryptor.defaultValidator,
      });

  @override
  State<ControlledTextField> createState() => _ControlledTextFieldState();
}

class _ControlledTextFieldState extends State<ControlledTextField> {
  // This key is used only to differentiate it from everything else in the widget
  // tree
  final _formKey = GlobalKey<FormState>();
  // this is used to control and track the text that is in the field
  final textController = TextEditingController();
  // This is used to requrest focus on the field
  final textFocusNode = FocusNode();
  // We obscure text by default
  bool _isObscured = true;

  @override
  void dispose() {
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          //  This will only attempt to validate the field if user interacted
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _isObscured,
          focusNode: textFocusNode,
          // changes the keybaord that the system displays to one that supports
          // email addressing with the @.
          keyboardType: TextInputType.emailAddress,
          controller: textController,
          decoration: InputDecoration(
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            suffixIcon: IconButton(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              icon: _isObscured
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              // Updates the state of the widget, requests a redraw.
              onPressed: () => setState(() => _isObscured = !_isObscured),
            ),
            hintText: widget.hintText,
          ),
          // Call whatever function is supplied.
          validator: widget.validator,
        ));
  }
}

//
// class ControlledInputDialog extends StatefulWidget  {
//   final Widget? title;
//   final Widget? content;
//   final Key inputFieldKey;
//   final String inputHintText;
//   final String? Function(String?) validator;
//   final List<ButtonStyleButton> actions;
//   final List<void Function()> actionsOnPressedList;
//
//
//   const ControlledInputDialog({
//     super.key,
//     required this.title,
//     required this.content,
//     required this.inputFieldKey,
//     required this.inputHintText,
//     required this.validator,
//     required this.actions,
//     required this.actionsOnPressedList
//   });
//
//   @override
//   State<ControlledInputDialog> createState() => _ControlledInputDialogState();
// }
//
// class _ControlledInputDialogState extends State<ControlledInputDialog> {
//   bool isInputValid = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//         backgroundColor: Theme.of(context).colorScheme.onBackground,
//         title: widget.title,
//         content: ControlledTextField(
//             key: widget.inputFieldKey,
//             hintText: widget.inputHintText,
//             validator: (value) {
//                 String? result = widget.validator.call(value);
//                 if(result == null || result.isEmpty){
//                    setState(() {
//                      isInputValid  = true;
//                    });
//                 } else {
//                   setState(() {
//                     isInputValid = false;
//                   });
//                 }
//                 return result;
//             },
//     ),
//     actions: [
//     );
//   }
//}
