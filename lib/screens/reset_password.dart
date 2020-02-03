import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  String emailField;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text('Reset Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              'Reset Password',
              style: kTitleStyle,
            )),
            SizedBox(
              height: 30,
            ),
            SignInTextFields(
                inputLabel: 'Email',
                hideText: false,
                onChanged: (newValue) {
                  emailField = newValue;
                }),
            SizedBox(
              height: 10,
            ),
            SubmitButton(
              label: 'Send Email',
              onTapped: () async {
                try {
                  await _auth.sendPasswordResetEmail(email: emailField);
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
              },
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
