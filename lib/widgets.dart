import 'package:flutter/material.dart';

import 'constants.dart';

class SignInTextFields extends StatelessWidget {
  SignInTextFields(
      {this.inputAction = TextInputAction.continueAction,
      @required this.inputLabel,
      this.hideText = false,
      @required this.onChanged,
      this.inputType,
      this.controller});

  final TextEditingController controller;
  final String inputLabel;
  final bool hideText;
  final Function onChanged;
  final TextInputAction inputAction;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          keyboardType: inputType,
          controller: controller,
          textInputAction: inputAction,
          onChanged: onChanged,
          obscureText: hideText,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          autofocus: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue,
            hintText: inputLabel,
            labelText: inputLabel,
            labelStyle: TextStyle(color: Colors.white),
            hintStyle:
                TextStyle(color: Colors.white30, fontStyle: FontStyle.italic),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Colors.redAccent, style: BorderStyle.solid)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white)),
          )),
    );
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({@required this.label, @required this.onTapped});

  final String label;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        color: kAppBarColor,
        child: Text(
          label,
          style: kFlatButtonTextStlye,
        ),
        onPressed: onTapped,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
