import 'package:flutter/material.dart';
//add new line for dashboard import
import 'package:app/pages/dashboard.dart';

/// This is used as a password field, but can be used for any generic secrets
/// It supports hintText from the TextFormField widget, and will display
/// what you provide inside of the field
///
/// Use the validator to provide validation to your field, this is required
/// and returns null if valid.
class PasswordField extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  const PasswordField(
      {super.key, this.hintText = "Password", required this.validator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}
class _PasswordFieldState extends State<PasswordField> {
  // This key is used only to differentiate it from everything else in the widget
  // tree
  final _formKey = GlobalKey<FormState>();
  // this is used to control and track the text that is in the field
  final passwordController = TextEditingController();
  // This is used to requrest focus on the field
  final passwordFocusNode = FocusNode();
  // We obscure text by default
  bool _isObscured = true;

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          //add in case for when user submits the form
          onFieldSubmitted: (value) {
            String? access = widget.validator!(value);
            //clear text on any submission, whether its passed or not
            passwordController.text = "";
            //if form has correct then direct to next page
            if (access == 'Access Granted') {
              //go to dashboard
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()));
            }
          },
          //  This will only attempt to validate the field if user interacted
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _isObscured,
          focusNode: passwordFocusNode,
          // changes the keybaord that the system displays to one that supports
          // email addressing with the @.
          keyboardType: TextInputType.emailAddress,
          controller: passwordController,
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
              // Updates the staet of the widget, requests a redraw.
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
            hintText: widget.hintText,
            icon: const Icon(Icons.lock),
          ),
          // Call whatever function is supplied.
          validator: (value) => widget.validator!.call(value),
        ));
  }
}
