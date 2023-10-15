import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  const PasswordField({
        super.key,
        this.hintText = "Password",
        required this.validator
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  bool _isObscured = true;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: _isObscured,
            focusNode: passwordFocusNode,
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
                icon: _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                onPressed: () {setState(() { _isObscured = ! _isObscured; }); },
              ),
              hintText: widget.hintText,
              icon: const Icon(Icons.lock),
            ),
            validator: (value) => widget.validator!.call(value),
          )
    );
  }
}